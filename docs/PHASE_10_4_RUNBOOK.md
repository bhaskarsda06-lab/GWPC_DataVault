# Phase 10.4 Runbook

## 1. Confirm production target
```cmd
dbt debug --target prod
```

Expected: `All checks passed!`

## 2. Run smoke tests
```cmd
dbt test --target prod --select path:tests/smoke_production
```

## 3. Review failures
A smoke test should return zero rows when it represents a failure condition.

## 4. Confirm population
Use:
```text
deployment/post_deployment_smoke.sql
```

All critical production objects should exist and contain expected non-zero data for the current sample deployment.

## 5. Handover
Record:
- deployment timestamp
- git commit
- dbt version
- Databricks adapter version
- production catalog/schema
- test result
- operator
- incident/rollback reference if applicable
