-- Phase 6 DQ: Satellite audit-column validation.
SELECT 'sat_account_core' AS object_name, account_hk AS hk
FROM {{ ref('sat_account_core') }}
WHERE account_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
UNION ALL
SELECT 'sat_account_status', account_hk
FROM {{ ref('sat_account_status') }}
WHERE account_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
UNION ALL
SELECT 'sat_contact_details', contact_hk
FROM {{ ref('sat_contact_details') }}
WHERE contact_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
UNION ALL
SELECT 'sat_policy_details', policy_hk
FROM {{ ref('sat_policy_details') }}
WHERE policy_hk IS NULL OR load_dts IS NULL OR hashdiff IS NULL
