# ============================================================
# CONFIG
# ============================================================

CATALOG = "autdbt_vault_prod"
SCHEMA = "autdbtt"

EXECUTION_SUMMARY_TABLE = f"{CATALOG}.{SCHEMA}.dbt_execution_summary"
MODEL_EXECUTIONS_TABLE = f"{CATALOG}.{SCHEMA}.dbt_model_executions"


# ============================================================
# MAIN
# ============================================================

decision = "dbt_build"


# ------------------------------------------------------------
# 1. Query control tables for error or skip models
# ------------------------------------------------------------

status_query = f"""
WITH latest_invocation AS (
    SELECT invocation_id
    FROM {EXECUTION_SUMMARY_TABLE}
    ORDER BY loaded_at DESC
    LIMIT 1
)
SELECT
    m.unique_id,
    m.status
FROM {MODEL_EXECUTIONS_TABLE} m
WHERE m.resource_type = 'model'
  AND m.invocation_id = (
      SELECT invocation_id FROM latest_invocation
  )
  AND LOWER(m.status) IN ('error', 'fail', 'skip')
"""

try:

    print("=" * 80)
    print("GWPC DataVault PROD")
    print("DBT Status Check (Control Tables)")
    print("=" * 80)

    # ------------------------------------------------
    # 1a. First-run detection: are there any records?
    # ------------------------------------------------

    count_query = f"""
        SELECT COUNT(*) AS cnt
        FROM {EXECUTION_SUMMARY_TABLE}
    """

    total_records = spark.sql(count_query).collect()[0]["cnt"]

    print(f"\nTotal execution summary records: {total_records}")

    if total_records == 0:

        print("\n========================================")
        print("FIRST RUN - NO RECORDS IN CONTROL TABLES")
        print("========================================")
        print("Decision = dbt_build")

    else:

        # --------------------------------------------
        # 1b. Check latest invocation for error/skip
        # --------------------------------------------

        error_skip_df = spark.sql(status_query)
        error_skip_models = error_skip_df.collect()

        print(f"\nError/Skip model count: {len(error_skip_models)}")

        if error_skip_models:

            decision = "dbt_retry_existing"

            print("\n========================================")
            print("ERROR OR SKIP MODELS FOUND")
            print("========================================")

            for row in error_skip_models:

                print(f"MODEL: {row.unique_id} | STATUS: {row.status}")

            print(
                f"\nError/Skip model count = "
                f"{len(error_skip_models)}"
            )

        else:

            print("\n========================================")
            print("ALL MODELS SUCCESSFUL - NO ERROR OR SKIP")
            print("========================================")
            print("Decision = dbt_build")


except Exception as e:

    print(f"\nError querying control tables: {e}")
    print("Defaulting to dbt_build")
    decision = "dbt_build"


# ============================================================
# 2. SET DATABRICKS TASK VALUE
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
