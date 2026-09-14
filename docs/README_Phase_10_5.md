# Phase 10.5 — Production Operational Monitoring & Job Control

## Objective
Establish the operational control layer for the GWPC Data Vault production deployment.

This phase is designed around:
- pre-run validation
- controlled dbt execution
- post-run validation
- failure detection
- retry guidance
- operational audit capture
- production monitoring queries
- job-control runbook

The supplied SQL checks are read-only. The job configuration is a template and must be connected to the organization's scheduler/Databricks Jobs process.

## Important
Do not hard-code secrets or Databricks tokens into these files.
Use Databricks secret scopes, service principals, or the organization's approved credential mechanism.

## Validation
Run the operational tests after Phase 10.4:

```cmd
dbt test --target prod --select path:tests/operational
```

Expected:
```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```

## Production execution pattern

1. `dbt debug --target prod`
2. `dbt deps --target prod`
3. `dbt parse --target prod`
4. `dbt build --target prod`
5. `dbt test --target prod --select path:tests/operational`
6. Capture run metadata in the organization's scheduler/job system.
7. Alert on failure.
8. Retry only according to the runbook.

## Recommended retry policy

- Retry transient warehouse/connectivity failures after investigation.
- Do not blindly retry SQL/data-quality failures.
- Preserve the failed run output before retry.
- If a second attempt fails, stop and investigate.
