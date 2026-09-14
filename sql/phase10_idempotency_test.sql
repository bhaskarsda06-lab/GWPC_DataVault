-- ============================================================
-- Phase 10 Idempotency Test
-- Run the production workflow twice against the same source snapshot
-- or use a controlled DEV/TEST copy.
-- ============================================================

SELECT 'hub_account' AS object_name, COUNT(*) AS total_rows,
       COUNT(DISTINCT account_hk) AS distinct_hk
FROM autdbt_vault_test.autdbts.hub_account
UNION ALL
SELECT 'hub_contact', COUNT(*), COUNT(DISTINCT contact_hk)
FROM autdbt_vault_test.autdbts.hub_contact
UNION ALL
SELECT 'hub_policy', COUNT(*), COUNT(DISTINCT policy_hk)
FROM autdbt_vault_test.autdbts.hub_policy;

SELECT
    'sat_account_core' AS object_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT_WS('|', account_hk, hashdiff)) AS distinct_hk_hashdiff
FROM autdbt_vault_test.autdbts.sat_account_core
UNION ALL
SELECT
    'sat_account_status',
    COUNT(*),
    COUNT(DISTINCT CONCAT_WS('|', account_hk, hashdiff))
FROM autdbt_vault_test.autdbts.sat_account_status
UNION ALL
SELECT
    'sat_contact_details',
    COUNT(*),
    COUNT(DISTINCT CONCAT_WS('|', contact_hk, hashdiff))
FROM autdbt_vault_test.autdbts.sat_contact_details
UNION ALL
SELECT
    'sat_policy_details',
    COUNT(*),
    COUNT(DISTINCT CONCAT_WS('|', policy_hk, hashdiff))
FROM autdbt_vault_test.autdbts.sat_policy_details;
