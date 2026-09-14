-- Phase 9.3: Hash Key Validation - Policy Hub
SELECT policy_hk
FROM {{ ref('hub_policy') }}
WHERE policy_hk IS NULL OR TRIM(CAST(policy_hk AS STRING)) = ''
