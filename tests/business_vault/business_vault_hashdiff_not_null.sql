-- Phase 8.5
WITH checks AS (
 SELECT 'sat_account_contact_role' satellite_name,COUNT(*) invalid_count FROM {{ ref('sat_account_contact_role') }} WHERE hashdiff IS NULL
 UNION ALL
 SELECT 'sat_policy_contact_role',COUNT(*) FROM {{ ref('sat_policy_contact_role') }} WHERE hashdiff IS NULL
)
SELECT * FROM checks WHERE invalid_count>0
