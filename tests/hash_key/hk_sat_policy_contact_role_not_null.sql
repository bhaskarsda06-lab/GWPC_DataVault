-- Phase 9.3: Hash Key Validation - Policy Contact Role Satellite
SELECT policy_contact_role_hk
FROM {{ ref('sat_policy_contact_role') }}
WHERE policy_contact_role_hk IS NULL
   OR TRIM(CAST(policy_contact_role_hk AS STRING)) = ''
