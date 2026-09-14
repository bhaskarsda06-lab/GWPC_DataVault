-- Phase 9.6: All six satellites require populated, non-future load timestamps.
SELECT 'sat_account_core' AS model_name, account_hk AS parent_hk, load_dts
FROM {{ ref('sat_account_core') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
UNION ALL
SELECT 'sat_account_status', account_hk, load_dts
FROM {{ ref('sat_account_status') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
UNION ALL
SELECT 'sat_contact_details', contact_hk, load_dts
FROM {{ ref('sat_contact_details') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
UNION ALL
SELECT 'sat_policy_details', policy_hk, load_dts
FROM {{ ref('sat_policy_details') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
UNION ALL
SELECT 'sat_account_contact_role', account_contact_role_hk, load_dts
FROM {{ ref('sat_account_contact_role') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
UNION ALL
SELECT 'sat_policy_contact_role', policy_contact_role_hk, load_dts
FROM {{ ref('sat_policy_contact_role') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
