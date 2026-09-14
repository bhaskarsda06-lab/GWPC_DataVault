-- Phase 9 operational SLA check
-- Adjust SLA minutes to the approved production SLA.

WITH latest_runs AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY job_name, environment
            ORDER BY start_ts DESC
        ) AS rn
    FROM autdbt_vault_prod.autdbts.dv_job_run_control
)
SELECT
    run_id,
    job_name,
    environment,
    start_ts,
    end_ts,
    status,
    CASE
        WHEN end_ts IS NULL THEN NULL
        ELSE (unix_timestamp(end_ts) - unix_timestamp(start_ts)) / 60.0
    END AS duration_minutes
FROM latest_runs
WHERE rn <= 20
ORDER BY start_ts DESC;
