import json
import os

RUN_RESULTS_FILE = "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"

def decide_dbt_task(file_path):

    if not os.path.exists(file_path):
        return "dbt_build"

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading run_results.json: {e}")
        return "dbt_retry_existing"

    results = data.get("results", [])

    if not results:
        return "dbt_build"

    for result in results:
        status = result.get("status", "").lower()

        print(
            f"Model: {result.get('unique_id')} "
            f"Status: {status}"
        )

        if status in ("error", "skipped"):
            return "dbt_retry_existing"

    return "dbt_build"


decision = decide_dbt_task(RUN_RESULTS_FILE)

print(f"DBT_DECISION = {decision}")

dbutils.jobs.taskValues.set(
    key="dbt_decision",
    value=decision
)