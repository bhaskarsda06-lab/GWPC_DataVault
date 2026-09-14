-- ============================================================
-- Phase 6 - Control / Audit Tables
-- DEV bootstrap/reference SQL
-- Production deployment should be automated through the repository.
-- ============================================================

CREATE CATALOG IF NOT EXISTS autdbt_vault_dev;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.autdbts;

USE CATALOG autdbt_vault_dev;
USE SCHEMA autdbts;

CREATE TABLE IF NOT EXISTS dv_job_run_control (
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
    source_row_count BIGINT,
    target_row_count BIGINT,
    created_ts TIMESTAMP NOT NULL,
    updated_ts TIMESTAMP NOT NULL
) USING DELTA;

CREATE TABLE IF NOT EXISTS dv_dq_result (
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

CREATE TABLE IF NOT EXISTS dv_reconciliation (
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
