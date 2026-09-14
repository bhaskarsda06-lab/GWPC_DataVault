# Phase 11 Runbook — Production Automation & Orchestration

## 1. Logical workflow

1. Start scheduled/manual run.
2. Validate environment.
3. Validate dbt project.
4. Execute production build.
5. Validate critical production keys.
6. Validate relationships.
7. Validate satellites.
8. Execute operational/security/audit controls.
9. Publish run evidence.
10. Notify success or failure.

## 2. Recommended task dependency

```text
START
  |
  v
PRECHECK
  |
  v
DBT BUILD
  |
  +----> BUILD FAILURE ----> FAILURE HANDLER
  |
  v
CRITICAL VALIDATION
  |
  +----> VALIDATION FAILURE ----> FAILURE HANDLER
  |
  v
OPERATIONAL VALIDATION
  |
  v
AUDIT / EVIDENCE
  |
  v
SUCCESS
```

## 3. Pre-checks

At minimum:
- production connection available
- expected target is `prod`
- dbt project parses
- dependencies are installed
- source availability is confirmed by the upstream process
- no conflicting production run is active

## 4. Build

Recommended primary command:

```cmd
dbt build --target prod
```

The existing project build contains staging, Raw Vault, Business Vault and associated tests through dbt's dependency graph.

Do not replace `dbt build` with an arbitrary model list unless the dependency graph has been reviewed.

## 5. Post-build validation

Run the required production control suites, for example:

```cmd
dbt test --target prod --select path:tests/smoke_production
dbt test --target prod --select path:tests/operational
dbt test --target prod --select path:tests/alerting_recovery
dbt test --target prod --select path:tests/security_governance
dbt test --target prod --select path:tests/audit_lineage_compliance
dbt test --target prod --select path:tests/sla_performance
dbt test --target prod --select path:tests/dr_backup
dbt test --target prod --select path:tests/orchestration
```

## 6. Failure handling

If a task fails:
- capture run ID
- capture failing task
- capture dbt invocation and exit code
- preserve logs
- do not automatically perform destructive recovery
- retry only according to the approved retry policy
- escalate after retry exhaustion
- rerun from the correct dependency boundary after remediation

## 7. Concurrency

Only one production run should modify the same target objects at a time unless the platform design explicitly supports concurrent execution.

The actual concurrency mechanism must be configured in the production scheduler/job.

## 8. Scheduling

Use the approved business schedule. This package deliberately leaves schedule as `<TBD>`.

## 9. Evidence

For every production run retain:
- run ID
- start/end timestamps
- commit/version
- target/environment
- dbt invocation
- task statuses
- row-count/reconciliation evidence where required
- test result
- failure/retry information
- notification result

## 10. Manual recovery

A manual run should use the same production control path as the scheduled run wherever possible.
