{{ config(
    materialized='incremental',
    tags=['control', 'audit']
) }}

SELECT
    CAST('{{ invocation_id }}' AS STRING) AS run_id,
    'gwpc_datavault' AS job_name,
    '{{ target.name }}' AS environment,
    'dbt_build' AS pipeline_name,
    current_timestamp() AS start_ts,
    current_timestamp() AS end_ts,
    'STARTED' AS status,
    CAST(NULL AS STRING) AS failed_stage,
    0 AS retry_count,
    CAST(NULL AS STRING) AS error_message,
    CAST(NULL AS BIGINT) AS source_row_count,
    CAST(NULL AS BIGINT) AS target_row_count,
    current_timestamp() AS created_ts,
    current_timestamp() AS updated_ts
