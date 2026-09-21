import json
import os

RUN_RESULTS_FILE = "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"


def check_model_status(file_path):

    if not os.path.exists(file_path):
        print("run_results.json not found")
        return "dbt_build"

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        print(f"Unable to read run_results.json: {e}")
        return "dbt_build"

    failed_models = []

    for result in data.get("results", []):

        unique_id = result.get("unique_id", "")
        status = result.get("status", "").lower()

        # ONLY MODEL RESULTS
        if unique_id.startswith("model."):

            print(f"MODEL = {unique_id} | STATUS = {status}")

            if status in ("error", "fail"):
                failed_models.append(unique_id)

    if failed_models:

        print("\nMODEL FAILURES")
        print("================")

        for model in failed_models:
            print(model)

        print(f"\nFailed model count = {len(failed_models)}")
        print("Decision = dbt_retry_existing")

        decision = "dbt_retry_existing"

    else:

        print("\nNo model failures")
        print("Tests/reconciliation results ignored")
        print("Decision = dbt_build")

        decision = "dbt_build"

    dbutils.jobs.taskValues.set(
        key="dbt_decision",
        value=decision
    )

    return decision


decision = check_model_status(RUN_RESULTS_FILE)

print(f"\nFINAL DECISION = {decision}")