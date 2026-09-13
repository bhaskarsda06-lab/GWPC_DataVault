# Phase 1 - Databricks DEV Setup

Proposed DEV:
- Catalog: `autdbt_vault_dev`
- Schema: `autdbts`

Use an approved Databricks SQL Warehouse for dbt development.

Run:
```sql
CREATE CATALOG IF NOT EXISTS autdbt_vault_dev;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.autdbts;
SHOW SCHEMAS IN autdbt_vault_dev;
```

Do not manually create the Data Vault target tables in Phase 1.
dbt/AutomateDV will manage those in Phase 2.

For local authentication, use the authentication method approved by your organization.
For CI/CD, the planned production approach is OIDC/workload identity federation with
a service principal; do not put long-lived credentials in Git.
