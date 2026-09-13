GWPC DATA VAULT - CORRECTED DEMO SOURCE SQL

Files:
1. 01_DDL.sql
2. 02_INPUT_DATA.sql
3. 03_VERIFY_INPUT.sql

Project/catalog:
  autdbt_vault_dev.autdbts

IMPORTANT:
- These are DEMO source/input tables for the current dbt staging project.
- 01_DDL.sql drops and recreates the DEMO tables.
- Do NOT run 01_DDL.sql against real Guidewire production/source data.
- The latest dbt log showed that the staging models use "retired = 0".
  Therefore the seven affected PC tables now contain retired INT.
- The latest dbt log showed stg_accountcontactrole_type expects typecode.
  Therefore pctl_accountcontactrole_curr now contains typecode STRING.

EXECUTION ORDER IN DATABRICKS SQL:
  1. Run 01_DDL.sql
  2. Run 02_INPUT_DATA.sql
  3. Run 03_VERIFY_INPUT.sql

THEN FROM WINDOWS TERMINAL:
  cd C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault
  dbt build --select tag:staging --target dev

If the next dbt run reports another missing column, align the DEMO source
contract to the existing staging SQL instead of changing the Data Vault models
without checking the source contract.
