# Phase 6 - Data Quality, Reconciliation and Audit

## Objective

Add the control layer around the Raw Vault built in Phases 1-5.

Phase 6 covers:

1. Run control
2. DQ checks
3. Source-to-target reconciliation
4. Duplicate detection
5. Parent-Hub integrity
6. Audit status storage

## Control tables

### dv_job_run_control

Tracks:

- run ID
- job name
- environment
- start/end time
- status
- failed stage
- retry count
- error message
- source/target counts

### dv_dq_result

Stores individual DQ results.

### dv_reconciliation

Stores source-to-target count comparisons.

## DQ philosophy

A dbt test returns failing rows. The orchestration/control layer should capture
the run result and persist PASS/FAIL details into `dv_dq_result`.

Do not treat a zero-row dbt test as a persisted audit record automatically;
the job/controller must write the result.

## Reconciliation

Reconciliation compares the expected source population with the resulting
Raw Vault population.

Examples:

- account source population vs `hub_account`
- contact source population vs `hub_contact`
- policy source population vs `hub_policy`
- policy/contact relationship source population vs `link_policy_contact`

## Restartability boundary

Phase 6 establishes the metadata required for restartability but does not
claim a complete dependency-aware restart engine.

A production restart controller should be implemented after the stage/job
boundaries are finalized.
