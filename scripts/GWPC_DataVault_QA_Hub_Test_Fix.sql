-- ================================================================
-- GWPC Data Vault 2.0
-- QA SOURCE DATA FIX
-- Purpose:
--   Fix the current Hub business-key test errors in QA by adding
--   the source columns required by the existing Data Vault logic.
--
-- Current errors addressed:
--   1. pc_contact_curr.id is missing
--   2. pc_policyperiod_curr.policynumber is missing
--
-- IMPORTANT:
--   This script assumes the QA catalog is:
--       autdbt_vault_qa
--
--   If your QA catalog has a different name, replace
--   autdbt_vault_qa in this file before execution.
-- ================================================================

USE CATALOG autdbt_vault_qa;

-- ================================================================
-- STEP 1: Add Contact ID
-- Required by:
--   hub_contact_business_key
--   Existing Hub Contact hash-key logic
-- ================================================================

ALTER TABLE autdbt_vault_qa.autdbts.pc_contact_curr
ADD COLUMNS (
    id BIGINT
);

-- Populate deterministic demo IDs.
-- Existing non-null IDs are preserved.
UPDATE autdbt_vault_qa.autdbts.pc_contact_curr
SET id =
    CASE
        WHEN id IS NOT NULL THEN id
        ELSE ROW_NUMBER() OVER (ORDER BY publicid) + 1000
    END;

-- ================================================================
-- STEP 2: Add Policy Number
-- Required by:
--   hub_policy_business_key
--   Existing Hub Policy hash-key logic
-- ================================================================

ALTER TABLE autdbt_vault_qa.autdbts.pc_policyperiod_curr
ADD COLUMNS (
    policynumber STRING
);

-- Populate PolicyNumber from the Policy Public ID when it is
-- currently empty. For demo QA data such as POL001, this produces
-- P10001, etc.
UPDATE autdbt_vault_qa.autdbts.pc_policyperiod_curr
SET policynumber =
    CASE
        WHEN policynumber IS NOT NULL
             AND TRIM(policynumber) <> ''
            THEN policynumber
        WHEN policypublicid IS NOT NULL
             AND TRIM(policypublicid) <> ''
            THEN CONCAT(
                'P1',
                REGEXP_EXTRACT(policypublicid, '(\\d+)$', 1)
            )
        ELSE NULL
    END;

-- ================================================================
-- STEP 3: Verify Contact
-- ================================================================

SELECT
    id,
    publicid,
    firstname,
    lastname,
    email,
    retired
FROM autdbt_vault_qa.autdbts.pc_contact_curr
ORDER BY id;

-- ================================================================
-- STEP 4: Verify Policy
-- ================================================================

SELECT
    publicid,
    policypublicid,
    policynumber,
    periodnumber,
    termnumber,
    retired
FROM autdbt_vault_qa.autdbts.pc_policyperiod_curr
ORDER BY publicid;

-- ================================================================
-- STEP 5: NULL checks
-- ================================================================

SELECT
    'pc_contact_curr.id' AS check_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_rows
FROM autdbt_vault_qa.autdbts.pc_contact_curr

UNION ALL

SELECT
    'pc_policyperiod_curr.policynumber' AS check_name,
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN policynumber IS NULL
                 OR TRIM(policynumber) = ''
            THEN 1 ELSE 0
        END
    ) AS null_rows
FROM autdbt_vault_qa.autdbts.pc_policyperiod_curr;

-- ================================================================
-- EXPECTED RESULT
--
-- pc_contact_curr.id                  -> null_rows = 0
-- pc_policyperiod_curr.policynumber  -> null_rows = 0
--
-- Then run from the dbt project:
--
-- dbt test --select hub_account_business_key hub_contact_business_key hub_policy_business_key --target qa
-- ================================================================
