-- Phase 9.5: Policy Details satellite parent HK must exist in Hub Policy.
SELECT s.policy_hk
FROM {{ ref('sat_policy_details') }} s
LEFT JOIN {{ ref('hub_policy') }} h
  ON s.policy_hk = h.policy_hk
 AND h.source_system_name = 'GWPC'
WHERE h.policy_hk IS NULL
