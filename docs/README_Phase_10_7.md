# Phase 10.7 — Production Security, Governance & Access Control

## Objective
Establish and validate the production security and governance control layer for the GWPC Data Vault.

Target:
- Catalog: `autdbt_vault_prod`
- Vault schema: `autdbtt`
- Staging schema: `autdbtt_autdbts`

## Scope
- least-privilege access
- Unity Catalog ownership and grants
- service-principal/job identity
- secret management
- production environment separation
- write protection
- audit/governance
- security validation

## Important
This package does not grant, revoke, or alter permissions automatically.
Actual Unity Catalog grants must be applied by an authorized administrator through the organization's approved process.

Never place Databricks tokens, passwords, or client secrets in Git, SQL files, YAML files, or logs.

## Validation
Run:

```cmd
dbt parse --target prod
dbt test --target prod --select path:tests/security_governance
```

Expected:

```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```
