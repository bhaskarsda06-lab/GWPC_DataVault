import json
import os

RUN_RESULTS_FILE = (
    "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"
)


def check_dbt_status(file_path):

    # --------------------------------------------------
    # 1. No run_results.json
    #    First execution / normal build
    # --------------------------------------------------
    if not os.path.exists(file_path):
        print("run_results.json not found")
        print("Decision: dbt_build")

        return "dbt_build"

    # --------------------------------------------------
    # 2. Read run_results.json
    # --------------------------------------------------
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

    except Exception as e:
        print(f"ERROR reading run_results.json: {e}")
        print("Decision: dbt_retry_existing")

        return "dbt_retry_existing"

    results = data.get("results", [])

    if not results:
        print("No results found")
        print("Decision: dbt_build")

        return "dbt_build"

    # --------------------------------------------------
    # Counters
    # --------------------------------------------------
    failed_models = []
    failed_tests = []
    skipped_models = []

    # --------------------------------------------------
    # 3. Analyze every result
    # --------------------------------------------------
    for result in results:

        unique_id = result.get("unique_id", "")
        status = result.get("status", "").lower()
        resource_type = unique_id.split(".", 1)[0]

        print(
            f"Resource={resource_type} "
            f"Name={unique_id} "
            f"Status={status}"
        )

        # ----------------------------------------------
        # MODEL
        # ----------------------------------------------
        if resource_type == "model":

            if status in ("error", "fail"):
                failed_models.append(unique_id)

            elif status == "skipped":
                skipped_models.append(unique_id)

        # ----------------------------------------------
        # TEST
        # ----------------------------------------------
        elif resource_type == "test":

            if status in ("error", "fail"):
                failed_tests.append(unique_id)

    # --------------------------------------------------
    # 4. MODEL FAILURE
    # --------------------------------------------------
    if failed_models:

        print("\nFAILED MODELS:")
        for model in failed_models:
            print(f"  {model}")

        print("\nDecision: dbt_retry_existing")

        return "dbt_retry_existing"

    # --------------------------------------------------
    # 5. TEST / RECONCILIATION FAILURE
    # --------------------------------------------------
    if failed_tests:

        print("\nFAILED TESTS:")
        for test in failed_tests:
            print(f"  {test}")

        print("\nDecision: reconciliation_failure")

        return "reconciliation_failure"

    # --------------------------------------------------
    # 6. Only skipped models
    # --------------------------------------------------
    if skipped_models:

        print("\nSKIPPED MODELS:")
        for model in skipped_models:
            print(f"  {model}")

        print("\nDecision: dbt_retry_existing")

        return "dbt_retry_existing"

    # --------------------------------------------------
    # 7. Everything successful
    # --------------------------------------------------
    print("\nAll models and tests passed")
    print("Decision: dbt_build")

    return "dbt_build"


# ======================================================
# MAIN
# ======================================================

decision = check_dbt_status(RUN_RESULTS_FILE)

print(f"\nFINAL DBT DECISION = {decision}")

dbutils.jobs.taskValues.set(
    key="dbt_decision",
    value=decision
)