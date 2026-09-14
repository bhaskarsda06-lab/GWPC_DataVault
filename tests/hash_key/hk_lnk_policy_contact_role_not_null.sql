-- Phase 9.3: Hash Key Validation - Policy Contact Role Link
SELECT policy_contact_role_hk
FROM {{ ref('lnk_policy_contact_role') }}
WHERE policy_contact_role_hk IS NULL OR TRIM(CAST(policy_contact_role_hk AS STRING)) = ''
