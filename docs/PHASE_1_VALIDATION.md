# Phase 1 Validation

Run from the activated `.venv`:

```
git --version
python --version
pip --version
databricks --version
dbt --version
git status
git remote -v
pip show dbt-core
pip show dbt-databricks
```

The command prompt should show `(.venv)`.

Databricks DEV verification:
```
SHOW CATALOGS;
SHOW SCHEMAS IN autdbt_vault_dev;
```

Phase 1 is complete when local tools, GitHub connection, and the DEV catalog/schema are ready.
