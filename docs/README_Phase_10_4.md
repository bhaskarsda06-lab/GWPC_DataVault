# Phase 10.4 — Post-Deployment Smoke Testing

## Objective
Independently validate the production deployment after the successful Phase 10.3 build.

Target:
- dbt target: prod
- Catalog: autdbt_vault_prod
- Vault schema: autdbtt
- Staging schema: autdbtt_autdbts

## Safety
These smoke tests are read-only. They do not create, update, or delete data.

## Run
From the GWPC_DataVault project root:

```cmd
dbt test --target prod --select path:tests/smoke_production
```

For a direct SQL smoke check:

```cmd
databricks sql
```

and execute `deployment/post_deployment_smoke.sql` against the production warehouse.

## Acceptance
All smoke tests must PASS with:
PASS > 0
WARN = 0
ERROR = 0

Do not proceed to operational handover if a critical smoke test fails.
