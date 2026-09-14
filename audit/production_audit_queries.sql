-- Phase 10.8 Production Audit Queries
-- READ ONLY.

-- 1. Production object row-count evidence
SELECT 'hub_account' AS object_name, COUNT(*) AS row_count
FROM autdbt_vault_prod.autdbtt.hub_account
UNION ALL
SELECT 'hub_contact', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_contact
UNION ALL
SELECT 'hub_policy', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_policy
UNION ALL
SELECT 'sat_account_core', COUNT(*)
FROM autdbt_vault_prod.autdbtt.sat_account_core
UNION ALL
SELECT 'sat_account_status', COUNT(*)
FROM autdbt_vault_prod.autdbtt.sat_account_status
UNION ALL
SELECT 'sat_contact_details', COUNT(*)
FROM autdbt_vault_prod.autdbtt.sat_contact_details
UNION ALL
SELECT 'sat_policy_details', COUNT(*)
FROM autdbt_vault_prod.autdbtt.sat_policy_details
UNION ALL
SELECT 'lnk_account_contact', COUNT(*)
FROM autdbt_vault_prod.autdbtt.lnk_account_contact
UNION ALL
SELECT 'lnk_account_contact_role', COUNT(*)
FROM autdbt_vault_prod.autdbtt.lnk_account_contact_role
UNION ALL
SELECT 'lnk_policy_account', COUNT(*)
FROM autdbt_vault_prod.autdbtt.lnk_policy_account
UNION ALL
SELECT 'lnk_policy_contact_role', COUNT(*)
FROM autdbt_vault_prod.autdbtt.lnk_policy_contact_role
UNION ALL
SELECT 'bridge_policy_account_contact', COUNT(*)
FROM autdbt_vault_prod.autdbtt.bridge_policy_account_contact;

-- 2. Latest audit timestamps from core Hubs/Satellite
SELECT 'hub_account' AS object_name, MAX(load_dts) AS latest_load_dts
FROM autdbt_vault_prod.autdbtt.hub_account
UNION ALL
SELECT 'hub_contact', MAX(load_dts)
FROM autdbt_vault_prod.autdbtt.hub_contact
UNION ALL
SELECT 'hub_policy', MAX(load_dts)
FROM autdbt_vault_prod.autdbtt.hub_policy
UNION ALL
SELECT 'sat_account_core', MAX(load_dts)
FROM autdbt_vault_prod.autdbtt.sat_account_core;

-- 3. Critical-key null evidence
SELECT 'hub_account' AS object_name, COUNT(*) AS null_count
FROM autdbt_vault_prod.autdbtt.hub_account
WHERE account_hk IS NULL
UNION ALL
SELECT 'hub_contact', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_contact
WHERE contact_hk IS NULL
UNION ALL
SELECT 'hub_policy', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_policy
WHERE policy_hk IS NULL;
