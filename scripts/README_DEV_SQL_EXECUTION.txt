GWPC DEV SQL EXECUTION ORDER

Project:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault

Databricks catalog:
autdbt_vault_dev

Run in Databricks SQL Editor:

1. Run 01_DDL_DEV.sql
2. Run 02_INPUT_DATA_DEV.sql
3. Run 03_VERIFY_DEV.sql

Expected source counts:
ACCOUNT                  5
CONTACT                  5
POLICY                   5
POLICY PERIOD            5
ACCOUNT CONTACT          5
ACCOUNT CONTACT ROLE     5
POLICY CONTACT ROLE      5
ADDRESS                  5
PAYMENT PLAN             5

Then from Windows CMD:

cd C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault

dbt parse --target dev

dbt build --select tag:staging --target dev

Then test the three Hub business keys:

dbt test --select hub_account_business_key hub_contact_business_key hub_policy_business_key --target dev

IMPORTANT:
- These scripts target DEV only.
- Catalog is autdbt_vault_dev.
- Source schema is autdbts.
- Target/staging schema is autdbtt.
- 02_INPUT_DATA_DEV.sql truncates the DEMO source tables before loading five demo rows.
- Do not run this input script against real production/source data.
