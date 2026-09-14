-- Stage status helper.
-- Use this query to inspect the most recent state of a pipeline run.

SELECT
    run_id,
    stage_name,
    stage_sequence,
    status,
    attempt_no,
    start_ts,
    end_ts,
    rows_affected,
    error_message,
    updated_ts
FROM ${CATALOG}.${SCHEMA}.dv_job_stage_control
WHERE run_id = '${RUN_ID}'
ORDER BY stage_sequence, attempt_no;
