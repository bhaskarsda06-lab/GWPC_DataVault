-- Phase 9.6: All six satellites require populated hashdiff values.
SELECT 'sat_account_core' AS model_name, account_hk AS parent_hk, hashdiff
FROM {{ ref('sat_account_core') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
UNION ALL
SELECT 'sat_account_status', account_hk, hashdiff
FROM {{ ref('sat_account_status') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
UNION ALL
SELECT 'sat_contact_details', contact_hk, hashdiff
FROM {{ ref('sat_contact_details') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
UNION ALL
SELECT 'sat_policy_details', policy_hk, hashdiff
FROM {{ ref('sat_policy_details') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
UNION ALL
SELECT 'sat_account_contact_role', account_contact_role_hk, hashdiff
FROM {{ ref('sat_account_contact_role') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
UNION ALL
SELECT 'sat_policy_contact_role', policy_contact_role_hk, hashdiff
FROM {{ ref('sat_policy_contact_role') }}
WHERE hashdiff IS NULL OR TRIM(CAST(hashdiff AS STRING)) = ''
