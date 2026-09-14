# Phase 7 Production Runbook

## Normal run

1. Deploy the approved Git commit as a Databricks Bundle.
2. Start the Databricks Job.
3. Monitor stages in order:
   - bootstrap
   - staging
   - hubs
   - links
   - satellites
   - reconciliation/DQ
   - finalize
4. Confirm final Job status is SUCCESS.
5. Confirm reconciliation differences are zero unless an approved exception
   exists.
6. Confirm critical DQ checks pass.

## Failure

If a stage fails:

1. Do not manually edit Data Vault tables.
2. Capture the Databricks run ID.
3. Query `dv_job_stage_control`.
4. Identify the first non-SUCCESS stage.
5. Inspect the recorded error.
6. Correct the code/configuration/source issue through Git.
7. Run CI.
8. Deploy the corrected commit.
9. Restart from the failed stage using the approved restart mechanism.
10. Re-run DQ and reconciliation.
11. Confirm final SUCCESS.

## Never

- Do not manually update Hub/Link/Satellite rows to fix a pipeline failure.
- Do not use `DELETE` to remove history as a normal restart method.
- Do not use `--full-refresh` as routine recovery.
- Do not use a developer's personal credentials for production execution.
- Do not put production secrets in Git.

## Production identity

The job should use a dedicated service principal as Run As identity.
The principal must have the required SQL warehouse and Unity Catalog
permissions.
