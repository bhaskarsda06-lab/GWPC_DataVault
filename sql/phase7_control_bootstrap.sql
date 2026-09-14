-- Phase 7 control bootstrap.
-- Run from the Git-controlled Databricks Bundle.
-- Control tables are operational metadata, not business Data Vault objects.

CREATE SCHEMA IF NOT EXISTS ${var.catalog_name}.${var.schema_name};

CREATE TABLE IF NOT EXISTS ${var.catalog_name}.${var.schema_name}.dv_job_stage_control (
    run_id STRING NOT NULL,
    stage_name STRING NOT NULL,
    stage_sequence INT NOT NULL,
    status STRING NOT NULL,
    start_ts TIMESTAMP,
    end_ts TIMESTAMP,
    attempt_no INT NOT NULL,
    rows_affected BIGINT,
    error_message STRING,
    updated_ts TIMESTAMP NOT NULL
) USING DELTA;

CREATE TABLE IF NOT EXISTS ${var.catalog_name}.${var.schema_name}.dv_job_run_control (
    run_id STRING NOT NULL,
    job_name STRING NOT NULL,
    environment STRING NOT NULL,
    pipeline_name STRING,
    start_ts TIMESTAMP NOT NULL,
    end_ts TIMESTAMP,
    status STRING NOT NULL,
    failed_stage STRING,
    retry_count INT DEFAULT 0,
    error_message STRING,
    created_ts TIMESTAMP NOT NULL,
    updated_ts TIMESTAMP NOT NULL
) USING DELTA;

CREATE TABLE IF NOT EXISTS ${var.catalog_name}.${var.schema_name}.dv_dq_result (
    run_id STRING NOT NULL,
    dq_check_id STRING NOT NULL,
    dq_check_name STRING NOT NULL,
    object_name STRING NOT NULL,
    check_type STRING NOT NULL,
    expected_value STRING,
    actual_value STRING,
    status STRING NOT NULL,
    error_message STRING,
    checked_ts TIMESTAMP NOT NULL
) USING DELTA;

CREATE TABLE IF NOT EXISTS ${var.catalog_name}.${var.schema_name}.dv_reconciliation (
    run_id STRING NOT NULL,
    reconciliation_id STRING NOT NULL,
    source_object STRING NOT NULL,
    target_object STRING NOT NULL,
    source_count BIGINT,
    target_count BIGINT,
    difference_count BIGINT,
    status STRING NOT NULL,
    reconciliation_ts TIMESTAMP NOT NULL,
    error_message STRING
) USING DELTA;
