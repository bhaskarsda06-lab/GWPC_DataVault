import json
import os

# ============================================================
# CONFIGURATION
# ============================================================

RUN_RESULTS_FILE = (
    "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"
)


# ============================================================
# CHECK DBT MODEL STATUS
# ============================================================

def check_dbt_model_status(file_path):

    # --------------------------------------------------------
    # 1. run_results.json does not exist
    # --------------------------------------------------------

    if not os.path.exists(file_path):

        print("run_results.json not found")
        print("Decision = dbt_build")

        return "dbt_build"


    # --------------------------------------------------------
    # 2. Read run_results.json
    # --------------------------------------------------------

    try:

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

    except Exception as e:

        print(f"Unable to read run_results.json: {e}")
        print("Decision = dbt_build")

        return "dbt_build"


    # --------------------------------------------------------
    # 3. Get results
    # --------------------------------------------------------

    results = data.get("results", [])

    if not results:

        print("No results found")
        print("Decision = dbt_build")

        return "dbt_build"


    # --------------------------------------------------------
    # 4. Check ONLY models
    # --------------------------------------------------------

    failed_models = []

    for result in results:

        unique_id = result.get("unique_id", "")
        status = result.get("status", "").lower()

        # Only model.*
        if unique_id.startswith("model."):

            model_name = unique_id.split(".")[-1]

            print(
                f"MODEL   = {model_name} "
                f"| STATUS = {status}"
            )

            # Only model error/fail matters
            if status in ("error", "fail"):

                failed_models.append({
                    "unique_id": unique_id,
                    "model_name": model_name,
                    "status": status
                })


    # --------------------------------------------------------
    # 5. Model failure found
    # --------------------------------------------------------

    if failed_models:

        print("\n===================================")
        print("MODEL FAILURE")
        print("===================================")

        for model in failed_models:

            print(
                f"Model  : {model['model_name']}\n"
                f"Unique : {model['unique_id']}\n"
                f"Status : {model['status']}\n"
            )

        print(
            f"Failed model count = {len(failed_models)}"
        )

        decision = "dbt_retry_existing"


    # --------------------------------------------------------
    # 6. No model failure
    # --------------------------------------------------------

    else:

        print("\n===================================")
        print("NO MODEL FAILURE")
        print("===================================")

        print("Tests ignored")
        print("Reconciliation failures ignored")
        print("Skipped tests ignored")
        print("Skipped models ignored")

        decision = "dbt_build"


    # --------------------------------------------------------
    # 7. Set Databricks task value
    # --------------------------------------------------------

    print(f"\nFINAL DBT DECISION = {decision}")

    dbutils.jobs.taskValues.set(
        key="dbt_decision",
        value=decision
    )

    print("Task value 'dbt_decision' successfully set.")

    return decision


# ============================================================
# MAIN
# ============================================================

decision = check_dbt_model_status(
    RUN_RESULTS_FILE
)

print(
    f"\nCHECK_DBT_STATUS completed successfully: {decision}"
)