# Phase 10 Failure / Restart Test Matrix

| Test | Injected failure | Expected result |
|---|---|---|
| F01 | Staging task fails | Job stops at staging |
| F02 | Hub task fails | Link/Satellite stages do not run |
| F03 | Link task fails | Satellite stage does not run |
| F04 | Satellite DQ fails | Reconciliation/finalization blocked |
| F05 | Reconciliation mismatch | Production run marked failed |
| F06 | Job retry | Same stage retries without duplicate HKs |
| F07 | Resume | Restart begins at approved failed stage |
| F08 | Duplicate source row | Hub/Link idempotency protects target |
| F09 | Changed Satellite payload | New Satellite history row is created |
| F10 | No source change | No duplicate Satellite row is created |

Each test must record:

- run ID
- commit SHA
- environment
- stage
- failure reason
- expected result
- actual result
- evidence
- approver
