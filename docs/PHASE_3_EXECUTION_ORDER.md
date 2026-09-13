# Phase 3 Execution Order

1. Confirm Phase 2 staging succeeds.
2. Run `dbt deps`.
3. Run Hub business-key tests.
4. Build the three Hubs.
5. Run Hub schema tests.
6. Verify Hub row counts and distinct hash keys in Databricks.
7. Compare sample hash keys with the supplied legacy SQL.

Commands:

```cmd
dbt deps
dbt test --select hub_account_business_key hub_contact_business_key hub_policy_business_key --target dev
dbt build --select tag:hub --target dev
dbt test --select path:models/raw_vault/hubs --target dev
```
