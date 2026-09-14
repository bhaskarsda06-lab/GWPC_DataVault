# Phase 10.5 Production Operations Runbook

## Daily production flow

### Pre-run
```cmd
dbt debug --target prod
dbt deps --target prod
dbt parse --target prod
```

### Main execution
```cmd
dbt build --target prod
```

### Post-run operational validation
```cmd
dbt test --target prod --select path:tests/operational
```

## Failure classification

### Type A — Connection / infrastructure
Examples:
- warehouse unavailable
- authentication failure
- temporary network failure

Action:
1. Preserve logs.
2. Verify Databricks warehouse/job status.
3. Verify credential availability without exposing secrets.
4. Retry when infrastructure is healthy.

### Type B — dbt compilation / dependency
Examples:
- package failure
- compilation error
- missing relation

Action:
1. Stop the run.
2. Review the changed code/package/profile.
3. Do not repeatedly retry.
4. Correct and validate in the approved environment.

### Type C — Data quality / reconciliation
Examples:
- null critical keys
- orphan records
- duplicate relationship keys
- reconciliation mismatch

Action:
1. Stop downstream promotion/handover.
2. Preserve failed test output.
3. Identify source/staging/vault layer.
4. Correct the root cause.
5. Re-run the relevant tests.
6. Run the full production validation before declaring success.

## Monitoring cadence

At minimum monitor:
- job success/failure
- execution duration
- model failures
- test failures
- source freshness when freshness tests are configured
- unexpected row-count changes
- orphan/duplicate/reconciliation failures
- repeated retries

## Security

Never place:
- Databricks access tokens
- passwords
- client secrets
- service-principal secrets

in SQL, YAML, Git, or job definitions in plaintext.

Use the organization's approved secret-management mechanism.
