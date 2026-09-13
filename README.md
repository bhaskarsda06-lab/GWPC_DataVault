# GWPC Data Vault 2.0 - Phase 1 Foundation

Phase 1 prepares the local development machine, Git repository, Python environment,
dbt tooling, Databricks CLI, and Databricks DEV catalog/schema.

Phase 1 does NOT create Hubs, Links, or Satellites. Those are created in Phase 2.

Proposed DEV target:
- Catalog: autdbt_vault_dev
- Schema: autdbts

Never commit passwords, tokens, service-principal secrets, or profiles.yml.
