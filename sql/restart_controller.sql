-- ============================================================
-- Phase 7 Restart Controller
-- Purpose: identify the first incomplete/failed stage for a run.
--
-- This query is intentionally deterministic. It does not silently rerun
-- downstream stages after an incomplete upstream stage.
-- ============================================================

WITH ranked AS (
    SELECT
        run_id,
        stage_name,
        stage_sequence,
        status,
        attempt_no,
        updated_ts,
        ROW_NUMBER() OVER (
            PARTITION BY run_id, stage_name
            ORDER BY attempt_no DESC, updated_ts DESC
        ) AS rn
    FROM ${CATALOG}.${SCHEMA}.dv_job_stage_control
    WHERE run_id = '${RUN_ID}'
),
latest AS (
    SELECT *
    FROM ranked
    WHERE rn = 1
),
first_incomplete AS (
    SELECT
        run_id,
        stage_name,
        stage_sequence,
        status,
        attempt_no
    FROM latest
    WHERE status <> 'SUCCESS'
    ORDER BY stage_sequence
    LIMIT 1
)
SELECT
    run_id,
    COALESCE(stage_name, 'complete') AS restart_stage,
    COALESCE(status, 'SUCCESS') AS stage_status,
    COALESCE(attempt_no, 0) AS previous_attempt
FROM first_incomplete

UNION ALL

SELECT
    '${RUN_ID}' AS run_id,
    'complete' AS restart_stage,
    'SUCCESS' AS stage_status,
    0 AS previous_attempt
WHERE NOT EXISTS (SELECT 1 FROM first_incomplete);
