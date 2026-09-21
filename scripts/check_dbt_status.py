import json
import os

# ============================================================
# CONFIG
# ============================================================

RUN_RESULTS_FILE = (
    "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"
)


# ============================================================
# MAIN
# ============================================================

decision = "dbt_build"
failed_models = []


# ------------------------------------------------------------
# 1. Check run_results.json
# ------------------------------------------------------------

if not os.path.exists(RUN_RESULTS_FILE):

    print("run_results.json not found")
    print("Decision = dbt_build")

else:

    try:

        with open(
            RUN_RESULTS_FILE,
            "r",
            encoding="utf-8"
        ) as f:

            data = json.load(f)

        results = data.get("results", [])

        print(f"Total dbt results = {len(results)}")


        # ----------------------------------------------------
        # 2. Check ONLY model results
        # ----------------------------------------------------

        for result in results:

            unique_id = result.get("unique_id", "")
            status = result.get("status", "").lower()

            # Ignore everything except models
            if not unique_id.startswith("model."):

                continue

            print(
                f"MODEL: {unique_id} | STATUS: {status}"
            )


            # ------------------------------------------------
            # 3. Actual model failure
            # ------------------------------------------------

            if status in ("error", "fail"):

                failed_models.append(unique_id)


        # ----------------------------------------------------
        # 4. Decide
        # ----------------------------------------------------

        if failed_models:

            decision = "dbt_retry_existing"

            print("\n========================================")
            print("MODEL FAILURE FOUND")
            print("========================================")

            for model in failed_models:

                print(f"FAILED MODEL: {model}")

            print(
                f"\nFailed model count = {len(failed_models)}"
            )

        else:

            decision = "dbt_build"

            print("\n========================================")
            print("NO MODEL FAILURE")
            print("========================================")

            print("Tests ignored")
            print("Reconciliation failures ignored")
            print("Skipped tests ignored")
            print("Skipped models ignored")


    except Exception as e:

        print(
            f"Error reading run_results.json: {e}"
        )

        # Do not trigger model recovery for a JSON read problem
        decision = "dbt_build"


# ============================================================
# 5. SET DATABRICKS TASK VALUE
# ============================================================

print("\n========================================")
print(f"FINAL DBT DECISION = {decision}")
print("========================================")

dbutils.jobs.taskValues.set(
    key="dbt_decision",
    value=decision
)

print(
    "Task value set successfully: "
    f"dbt_decision = {decision}"
)