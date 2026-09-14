# Phase 10.10 DR / Backup / Business Continuity Runbook

## 1. Before a DR event
Maintain:
- approved RPO
- approved RTO
- dependency inventory
- backup/restore procedure
- ownership and contacts
- evidence repository
- latest production validation results

## 2. DR event classification

### Infrastructure failure
Recover platform/warehouse dependencies first.

### Data/catalog failure
Recover the approved data/catalog layer according to the platform backup procedure.

### Application/dbt failure
Restore the approved code/deployment version and validate.

### Regional/service disruption
Follow the organization's approved regional failover procedure.

## 3. Recovery sequence

1. Declare incident if required.
2. Capture incident/run reference.
3. Identify affected dependencies.
4. Confirm last known good state.
5. Determine RPO impact.
6. Execute approved restore/failover.
7. Validate production connectivity.
8. Validate critical objects.
9. Run targeted tests.
10. Run Phase 10.4 smoke tests.
11. Run Phase 10.5 operational tests.
12. Validate downstream readiness.
13. Record actual recovery time.
14. Obtain business/technical approval.
15. Close incident.

## 4. RPO

RPO is the maximum acceptable amount of data loss measured in time.

Do not state that the current project has a particular RPO unless it is approved.

## 5. RTO

RTO is the maximum acceptable time to restore service.

Do not state that the current project has a particular RTO unless it is approved.

## 6. DR evidence
Record:
- incident ID
- start time
- detection time
- recovery start
- service restored time
- actual RTO
- last recoverable data point
- actual RPO
- validation results
- approver
