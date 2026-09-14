# Phase 10 Commands

## Local validation
```cmd
dbt deps --target dev
dbt debug --target dev
dbt parse --target dev
dbt compile --target dev
```

## Full validation
```cmd
dbt test --select path:tests/dq path:tests/business_key path:tests/hash_key --target dev
dbt test --select path:tests/duplicate_history path:tests/referential_integrity --target dev
dbt test --select path:tests/audit_metadata path:tests/reconciliation_metrics --target dev
dbt test --select path:tests/unit_logic path:tests/e2e_regression --target dev
```

## Build
```cmd
dbt build --target dev
```

For production, use the organization's approved CI/CD target and secret-management process.
