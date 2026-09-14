-- Phase 9.9: Required audit timestamps are populated throughout the vault chain.
WITH missing AS (
    SELECT 'hub_account' AS object_name FROM {{ ref('hub_account') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'hub_contact' FROM {{ ref('hub_contact') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'hub_policy' FROM {{ ref('hub_policy') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'lnk_policy_account' FROM {{ ref('lnk_policy_account') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'lnk_policy_contact_role' FROM {{ ref('lnk_policy_contact_role') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'lnk_account_contact' FROM {{ ref('lnk_account_contact') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'sat_account_core' FROM {{ ref('sat_account_core') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'sat_account_status' FROM {{ ref('sat_account_status') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'sat_contact_details' FROM {{ ref('sat_contact_details') }} WHERE load_dts IS NULL
    UNION ALL
    SELECT 'sat_policy_details' FROM {{ ref('sat_policy_details') }} WHERE load_dts IS NULL
)
SELECT object_name FROM missing
