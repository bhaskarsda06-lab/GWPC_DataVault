-- Phase 10.5 Production Monitoring Queries
-- READ ONLY. Adjust object names only if the production implementation differs.

-- 1. Production object population
SELECT 'hub_account' AS object_name, COUNT(*) AS row_count
FROM autdbt_vault_prod.autdbtt.hub_account
UNION ALL
SELECT 'hub_contact', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_contact
UNION ALL
SELECT 'hub_policy', COUNT(*)
FROM autdbt_vault_prod.autdbtt.hub_policy
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

-- 2. Critical Hub key null monitoring
SELECT 'hub_account' AS object_name, COUNT(*) AS null_key_count
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

-- 3. Bridge key null monitoring
SELECT COUNT(*) AS invalid_bridge_rows
FROM autdbt_vault_prod.autdbtt.bridge_policy_account_contact
WHERE policy_account_hk IS NULL
   OR policy_contact_role_hk IS NULL
   OR policy_account_contact_hk IS NULL;
