# Phase 3 Validation

Verify:

```sql
SHOW TABLES IN autdbt_vault_dev.autdbts;
```

Then:

```sql
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT account_hk) AS distinct_hk
FROM autdbt_vault_dev.autdbts.hub_account;
```

```sql
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT contact_hk) AS distinct_hk
FROM autdbt_vault_dev.autdbts.hub_contact;
```

```sql
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT policy_hk) AS distinct_hk
FROM autdbt_vault_dev.autdbts.hub_policy;
```

For each Hub, row count and distinct hash-key count should match.

Do not manually create Hub DDL tables.
