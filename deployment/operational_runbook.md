# Production Operational Runbook

## Daily/Per-Run Sequence
1. Confirm source availability.
2. Execute the approved dbt build.
3. Capture dbt results.
4. Execute DQ and reconciliation validation.
5. Check end-to-end regression.
6. Review failures/warnings.
7. Record run metadata.

## Failure Handling
- Do not ignore dbt errors.
- Do not bypass failed reconciliation or referential-integrity tests.
- Preserve logs before retrying.
- Retry only when the failure is understood or the approved operational procedure allows it.

## Incremental Models
Review incremental-model failures carefully before rerunning. Confirm whether the
failure happened before or after target-table changes.

## Success Criteria
A production run is considered successful only when:
- dbt build completes successfully
- required validation suites pass
- no unexplained warnings/errors remain
- post-deployment smoke checks pass
