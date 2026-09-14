-- Finalization task.
-- The Databricks Job run status is authoritative for execution success.
-- This table records a completion heartbeat for the control framework.

INSERT INTO ${var.catalog_name}.${var.schema_name}.dv_job_stage_control
SELECT
    '${job.run_id}',
    'finalize_run',
    99,
    'SUCCESS',
    current_timestamp(),
    current_timestamp(),
    1,
    NULL,
    NULL,
    current_timestamp();
