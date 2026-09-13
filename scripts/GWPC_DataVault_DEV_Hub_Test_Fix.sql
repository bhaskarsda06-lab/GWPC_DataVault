-- GWPC Data Vault 2.0
-- DEV SOURCE FIX
-- Purpose: fix the current Hub business-key test failures in DEV.
--
-- Current known failures:
--   1. pc_contact_curr.id is missing
--   2. pc_policyperiod_curr.policynumber is missing
--
-- DEV catalog confirmed for this project:
--   autdbt_vault_dev
--
-- This script is designed for Databricks Delta tables.
-- It uses MERGE instead of UPDATE + ROW_NUMBER(), so the ID generation
-- is deterministic and avoids unsupported UPDATE/window-function patterns.

USE CATALOG autdbt_vault_dev;

-- ============================================================
-- 1. Add CONTACT ID
-- ============================================================

ALTER TABLE autdbt_vault_dev.autdbts.pc_contact_curr
ADD COLUMNS (
    id BIGINT
);

-- Populate ID only where it is currently NULL.
-- Existing non-null IDs are preserved.
MERGE INTO autdbt_vault_dev.autdbts.pc_contact_curr AS tgt
USING (
    SELECT
        publicid,
        CAST(ROW_NUMBER() OVER (ORDER BY publicid) + 1000 AS BIGINT) AS generated_id
    FROM autdbt_vault_dev.autdbts.pc_contact_curr
    WHERE id IS NULL
      AND publicid IS NOT NULL
) AS src
ON tgt.publicid = src.publicid
WHEN MATCHED AND tgt.id IS NULL THEN
    UPDATE SET tgt.id = src.generated_id;

-- ============================================================
-- 2. Add POLICY PERIOD POLICY NUMBER
-- ============================================================

ALTER TABLE autdbt_vault_dev.autdbts.pc_policyperiod_curr
ADD COLUMNS (
    policynumber STRING
);

-- Populate PolicyNumber from the Policy source table.
-- This is preferable to fabricating a policy number from the
-- policy-period public ID.
MERGE INTO autdbt_vault_dev.autdbts.pc_policyperiod_curr AS tgt
USING (
    SELECT
        pp.publicid,
        p.policynumber
    FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr pp
    INNER JOIN autdbt_vault_dev.autdbts.pc_policy_curr p
        ON pp.policypublicid = p.publicid
    WHERE pp.policynumber IS NULL
       OR TRIM(pp.policynumber) = ''
) AS src
ON tgt.publicid = src.publicid
WHEN MATCHED THEN
    UPDATE SET tgt.policynumber = src.policynumber;

-- ============================================================
-- 3. VALIDATION
-- ============================================================

SELECT
    'pc_contact_curr.id' AS check_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_rows,
    COUNT(DISTINCT id) AS distinct_values
FROM autdbt_vault_dev.autdbts.pc_contact_curr;

SELECT
    'pc_policyperiod_curr.policynumber' AS check_name,
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN policynumber IS NULL OR TRIM(policynumber) = ''
            THEN 1 ELSE 0
        END
    ) AS null_rows,
    COUNT(DISTINCT policynumber) AS distinct_values
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr;

-- Detailed verification
SELECT
    id,
    publicid,
    firstname,
    middlename,
    lastname,
    email,
    phone,
    retired
FROM autdbt_vault_dev.autdbts.pc_contact_curr
ORDER BY id;

SELECT
    pp.publicid,
    pp.policypublicid,
    pp.policynumber,
    pp.periodnumber,
    pp.termnumber,
    pp.statuscode,
    pp.retired
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr pp
ORDER BY pp.publicid;

-- ============================================================
-- 4. AFTER RUNNING THIS SQL
-- ============================================================
-- From the GWPC_DataVault project folder run:
--
-- dbt test --select hub_account_business_key hub_contact_business_key hub_policy_business_key --target dev
--
-- Expected:
--   hub_account_business_key  PASS
--   hub_contact_business_key  PASS
--   hub_policy_business_key   PASS
--   ERROR = 0
