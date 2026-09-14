-- ============================================================
-- Phase 10 Production Smoke Test
-- Execute only after the approved Databricks Job completes.
-- Replace catalog/schema if enterprise names differ.
-- ============================================================

USE CATALOG autdbt_vault_prod;
USE SCHEMA autdbts;

-- 1. Object existence
SHOW TABLES;

-- 2. Hub counts
SELECT 'hub_account' AS object_name, COUNT(*) AS row_count
FROM hub_account
UNION ALL
SELECT 'hub_contact', COUNT(*) FROM hub_contact
UNION ALL
SELECT 'hub_policy', COUNT(*) FROM hub_policy

-- 3. Link count
UNION ALL
SELECT 'link_policy_contact', COUNT(*) FROM link_policy_contact;

-- 4. Satellite counts
SELECT 'sat_account_core' AS object_name, COUNT(*) AS row_count
FROM sat_account_core
UNION ALL
SELECT 'sat_account_status', COUNT(*) FROM sat_account_status
UNION ALL
SELECT 'sat_contact_details', COUNT(*) FROM sat_contact_details
UNION ALL
SELECT 'sat_policy_details', COUNT(*) FROM sat_policy_details;

-- 5. Critical null checks
SELECT 'hub_account_null_hk' AS check_name, COUNT(*) AS failures
FROM hub_account WHERE account_hk IS NULL
UNION ALL
SELECT 'hub_contact_null_hk', COUNT(*) FROM hub_contact WHERE contact_hk IS NULL
UNION ALL
SELECT 'hub_policy_null_hk', COUNT(*) FROM hub_policy WHERE policy_hk IS NULL
UNION ALL
SELECT 'sat_account_core_null_audit', COUNT(*)
FROM sat_account_core
WHERE account_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
UNION ALL
SELECT 'sat_contact_details_null_audit', COUNT(*)
FROM sat_contact_details
WHERE contact_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
UNION ALL
SELECT 'sat_policy_details_null_audit', COUNT(*)
FROM sat_policy_details
WHERE policy_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL;
