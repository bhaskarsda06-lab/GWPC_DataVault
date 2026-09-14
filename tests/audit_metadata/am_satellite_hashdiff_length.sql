-- Phase 9.6: SHA-256 hashdiff values must be 64 hexadecimal characters.
SELECT 'sat_account_core' AS model_name, account_hk AS parent_hk, hashdiff
FROM {{ ref('sat_account_core') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
UNION ALL
SELECT 'sat_account_status', account_hk, hashdiff
FROM {{ ref('sat_account_status') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
UNION ALL
SELECT 'sat_contact_details', contact_hk, hashdiff
FROM {{ ref('sat_contact_details') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
UNION ALL
SELECT 'sat_policy_details', policy_hk, hashdiff
FROM {{ ref('sat_policy_details') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
UNION ALL
SELECT 'sat_account_contact_role', account_contact_role_hk, hashdiff
FROM {{ ref('sat_account_contact_role') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
UNION ALL
SELECT 'sat_policy_contact_role', policy_contact_role_hk, hashdiff
FROM {{ ref('sat_policy_contact_role') }}
WHERE hashdiff IS NOT NULL
  AND NOT REGEXP_LIKE(CAST(hashdiff AS STRING), '^[0-9a-fA-F]{64}$')
