# Phase 10.6 Production Alerting, Failure Handling & Recovery Runbook

## 1. Alert severity

### P1 — Critical
Use when production data delivery is unavailable or a critical integrity issue is detected.

Examples:
- production build fails after approved retry
- critical Hub/Link/Bridge unavailable
- severe referential-integrity failure
- repeated production job failure

Action:
- stop downstream promotion
- notify on-call/data owner
- preserve logs
- open incident
- investigate root cause
- recover only after approval

### P2 — High
Examples:
- significant test failure
- unexpected reconciliation mismatch
- major runtime degradation

Action:
- stop downstream handover
- investigate
- correct and revalidate

### P3 — Medium
Examples:
- non-critical warning
- isolated operational anomaly

Action:
- record and investigate during normal support window.

## 2. Failure handling matrix

| Failure | Automatic retry | Stop pipeline | Recovery |
|---|---:|---:|---|
| Temporary warehouse/connectivity | Yes, max 1 | If retry fails | Retry after service check |
| Authentication | No blind retry | Yes | Fix credential/configuration |
| dbt compilation | No | Yes | Correct code/package |
| Data quality test | No blind retry | Yes | Fix data/root cause |
| Reconciliation mismatch | No blind retry | Yes | Investigate source-to-vault flow |
| Referential/orphan failure | No blind retry | Yes | Correct relationship/data issue |
| Timeout/performance | At most 1 after review | If repeat | Optimize/query/warehouse |

## 3. Evidence to retain

For every failed production run retain:
- job/run identifier
- deployment/Git commit
- dbt command
- target
- start/end time
- failed model/test
- error message
- relevant Databricks job/warehouse status
- retry result
- root cause
- corrective action
- final validation result

Never retain secrets in incident evidence.

## 4. Recovery sequence

1. Stop downstream consumption/promotion if integrity is uncertain.
2. Capture the failed run logs.
3. Classify the failure.
4. Determine whether retry is safe.
5. Fix infrastructure/configuration/code/data issue.
6. Re-run the smallest appropriate validation first.
7. Run production build/test as required.
8. Run Phase 10.4 smoke tests.
9. Run Phase 10.5 operational tests.
10. Obtain operational approval before closing the incident.

## 5. Rollback principle

Rollback should be implementation-specific and controlled by the deployment/IaC process.

Do not delete production vault objects as an ad-hoc rollback method.

For Data Vault, preserve historical data unless the approved recovery procedure explicitly requires otherwise.

## 6. Incident closure

Close only when:
- root cause is documented
- corrective action is documented
- production validation passes
- smoke tests pass
- operational tests pass
- downstream handover is approved
