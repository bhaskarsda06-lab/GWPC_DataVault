# Phase 2 Troubleshooting

## dbt command not found

Activate the virtual environment:

```cmd
.venv\Scripts\activate
```

Then:

```cmd
dbt --version
```

## AutomateDV package not found

Run:

```cmd
dbt deps
```

Check that `dbt_packages` exists locally.

It is intentionally ignored by Git.

## dbt debug fails

Check:
- Databricks host
- SQL Warehouse ID
- authentication
- catalog
- schema
- network access

## Source table not found

Verify:

```sql
SHOW TABLES IN autdbt_vault_dev.autdbts;
```

The Phase 2 staging layer assumes the GWPC source tables already exist.

## Permission error

The identity used by dbt needs sufficient Unity Catalog access to read the
source schema and create the configured staging objects.

Do not solve permission errors by putting credentials into the repository.
