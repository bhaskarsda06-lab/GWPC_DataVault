GWPC DATA VAULT SQL INPUT PACKAGE

Execution order in Databricks SQL Editor:
1. 01_DDL.sql
2. 02_INPUT_DATA.sql
3. 03_VERIFY_INPUT.sql
4. From the Windows project directory:
   dbt build --select tag:staging --target dev

IMPORTANT:
The DDL is a DEMO input/source contract based on the exact table names reported
as missing by the supplied dbt build log. It is intended to get the development
pipeline past the TABLE_OR_VIEW_NOT_FOUND stage.

It does NOT claim these are the complete or exact Guidewire PolicyCenter
schemas. If your existing staging SQL references additional columns, the next
error will identify those columns; then the source DDL should be aligned to
your actual source metadata.

The project currently references catalog autdbt_vault_dev and schema autdbts.
Do not change that naming unless your dbt project is intentionally configured
for another catalog/schema.
