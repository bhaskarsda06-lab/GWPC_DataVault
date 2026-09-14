# Phase 5 Execution Order

Run after Phase 2 staging, Phase 3 Hubs and Phase 4 Link are successful.

```cmd
dbt deps
dbt build --select tag:satellite --target dev
dbt test --select tag:satellite --target dev
```

Or run individually:

```cmd
dbt build --select sat_account_core --target dev
dbt build --select sat_account_status --target dev
dbt build --select sat_contact_details --target dev
dbt build --select sat_policy_details --target dev
```

Then:

```cmd
dbt test --select path:tests --target dev
```

Recommended inspection:

```sql
SELECT * FROM autdbt_vault_dev.autdbts.sat_account_core;
SELECT * FROM autdbt_vault_dev.autdbts.sat_account_status;
SELECT * FROM autdbt_vault_dev.autdbts.sat_contact_details;
SELECT * FROM autdbt_vault_dev.autdbts.sat_policy_details;
```
