-- Phase 9.9: Satellite hashdiff values are populated.
WITH missing AS (
    SELECT 'sat_account_core' AS object_name FROM {{ ref('sat_account_core') }} WHERE hashdiff IS NULL
    UNION ALL
    SELECT 'sat_account_status' FROM {{ ref('sat_account_status') }} WHERE hashdiff IS NULL
    UNION ALL
    SELECT 'sat_contact_details' FROM {{ ref('sat_contact_details') }} WHERE hashdiff IS NULL
    UNION ALL
    SELECT 'sat_policy_details' FROM {{ ref('sat_policy_details') }} WHERE hashdiff IS NULL
    UNION ALL
    SELECT 'sat_account_contact_role' FROM {{ ref('sat_account_contact_role') }} WHERE hashdiff IS NULL
    UNION ALL
    SELECT 'sat_policy_contact_role' FROM {{ ref('sat_policy_contact_role') }} WHERE hashdiff IS NULL
)
SELECT object_name FROM missing
