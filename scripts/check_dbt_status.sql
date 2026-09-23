-- ============================================================
-- Check DBT Status Query
-- ============================================================
-- Queries control tables to find models with error or skip
-- status from the latest dbt invocation.
--
-- Decision logic (handled by check_dbt_status.py):
--   * No records in control tables (first run) → dbt_build
--   * Query returns 0 rows (all success)       → dbt_build
--   * Query returns rows (error/skip models)    → dbt_retry_existing
-- ============================================================

WITH latest_invocation AS (
    SELECT invocation_id
    FROM autdbt_vault_prod.autdbtt.dbt_execution_summary
    ORDER BY loaded_at DESC
    LIMIT 1
)
SELECT
    m.unique_id,
    m.status
FROM autdbt_vault_prod.autdbtt.dbt_model_executions m
WHERE m.resource_type = 'model'
  AND m.invocation_id = (
      SELECT invocation_id FROM latest_invocation
  )
  AND LOWER(m.status) IN ('error', 'fail', 'skip')
