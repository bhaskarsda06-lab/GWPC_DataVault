-- Phase 9.3: Hash Key Validation - Policy Details Satellite
SELECT policy_hk
FROM {{ ref('sat_policy_details') }}
WHERE policy_hk IS NULL OR TRIM(CAST(policy_hk AS STRING)) = ''
