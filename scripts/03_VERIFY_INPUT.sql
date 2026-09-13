-- 03_VERIFY_INPUT.sql
-- Run AFTER 01_DDL.sql and 02_INPUT_DATA.sql.

USE CATALOG autdbt_vault_dev;

SELECT current_catalog() AS current_catalog, current_schema() AS current_schema;

SHOW SCHEMAS;
SHOW TABLES IN autdbts;

-- Check the two fixes from the latest dbt errors.
DESCRIBE TABLE autdbts.pc_account_curr;
DESCRIBE TABLE autdbts.pctl_accountcontactrole_curr;

SELECT publicid, retired, accountname, accountnumber, accounttype, status
FROM autdbts.pc_account_curr
ORDER BY publicid;

SELECT publicid, code, typecode, name
FROM autdbts.pctl_accountcontactrole_curr
ORDER BY publicid;

-- Row counts
SELECT 'pc_account_curr' AS object_name, COUNT(*) AS row_count FROM autdbts.pc_account_curr
UNION ALL SELECT 'pc_accountcontactrole_curr', COUNT(*) FROM autdbts.pc_accountcontactrole_curr
UNION ALL SELECT 'pc_accountcontact_curr', COUNT(*) FROM autdbts.pc_accountcontact_curr
UNION ALL SELECT 'pc_address_curr', COUNT(*) FROM autdbts.pc_address_curr
UNION ALL SELECT 'pc_contact_curr', COUNT(*) FROM autdbts.pc_contact_curr
UNION ALL SELECT 'pc_effectivedatedfields_curr', COUNT(*) FROM autdbts.pc_effectivedatedfields_curr
UNION ALL SELECT 'pc_paymentplansummary_curr', COUNT(*) FROM autdbts.pc_paymentplansummary_curr
UNION ALL SELECT 'pc_policy_curr', COUNT(*) FROM autdbts.pc_policy_curr
UNION ALL SELECT 'pc_policycontactrole_curr', COUNT(*) FROM autdbts.pc_policycontactrole_curr
UNION ALL SELECT 'pc_policyperiod_curr', COUNT(*) FROM autdbts.pc_policyperiod_curr
UNION ALL SELECT 'pctl_accountcontactrole_curr', COUNT(*) FROM autdbts.pctl_accountcontactrole_curr
UNION ALL SELECT 'pctl_accountstatus_curr', COUNT(*) FROM autdbts.pctl_accountstatus_curr
UNION ALL SELECT 'pctl_billingmethod_curr', COUNT(*) FROM autdbts.pctl_billingmethod_curr
UNION ALL SELECT 'pctl_country_curr', COUNT(*) FROM autdbts.pctl_country_curr
UNION ALL SELECT 'pctl_maritalstatus_curr', COUNT(*) FROM autdbts.pctl_maritalstatus_curr
UNION ALL SELECT 'pctl_jurisdiction_curr', COUNT(*) FROM autdbts.pctl_jurisdiction_curr
UNION ALL SELECT 'pctl_namesuffix_curr', COUNT(*) FROM autdbts.pctl_namesuffix_curr
UNION ALL SELECT 'pctl_state_curr', COUNT(*) FROM autdbts.pctl_state_curr
UNION ALL SELECT 'pctl_termtype_curr', COUNT(*) FROM autdbts.pctl_termtype_curr
UNION ALL SELECT 'pctl_policyperiodstatus_curr', COUNT(*) FROM autdbts.pctl_policyperiodstatus_curr;
