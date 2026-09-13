-- ============================================================
-- GWPC DEV INPUT VERIFICATION
-- ============================================================

SELECT 'ACCOUNT' AS entity, COUNT(*) AS cnt
FROM autdbt_vault_dev.autdbts.pc_account_curr
UNION ALL
SELECT 'CONTACT', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_contact_curr
UNION ALL
SELECT 'POLICY', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policy_curr
UNION ALL
SELECT 'POLICY PERIOD', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr
UNION ALL
SELECT 'ACCOUNT CONTACT', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_accountcontact_curr
UNION ALL
SELECT 'ACCOUNT CONTACT ROLE', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_accountcontactrole_curr
UNION ALL
SELECT 'POLICY CONTACT ROLE', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policycontactrole_curr
UNION ALL
SELECT 'ADDRESS', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_address_curr
UNION ALL
SELECT 'PAYMENT PLAN', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_paymentplansummary_curr;

SELECT
    publicid,
    id,
    firstname,
    lastname,
    email,
    retired
FROM autdbt_vault_dev.autdbts.pc_contact_curr
ORDER BY publicid;

SELECT
    publicid,
    policynumber,
    policypublicid,
    periodnumber,
    termnumber,
    statuscode,
    retired
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr
ORDER BY publicid;

-- Check required Hub business keys
SELECT
    COUNT(*) AS contact_rows,
    SUM(CASE WHEN publicid IS NULL OR TRIM(publicid) = '' THEN 1 ELSE 0 END) AS null_publicid,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_id
FROM autdbt_vault_dev.autdbts.pc_contact_curr;

SELECT
    COUNT(*) AS policy_period_rows,
    SUM(CASE WHEN publicid IS NULL OR TRIM(publicid) = '' THEN 1 ELSE 0 END) AS null_publicid,
    SUM(CASE WHEN policynumber IS NULL OR TRIM(policynumber) = '' THEN 1 ELSE 0 END) AS null_policynumber
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr;
