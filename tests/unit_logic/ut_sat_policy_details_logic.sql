-- Phase 9.8: Policy Details satellite must map to Policy Hub.
SELECT s.policy_hk
FROM {{ ref('sat_policy_details') }} s
LEFT JOIN {{ ref('hub_policy') }} h
  ON s.policy_hk = h.policy_hk
 AND h.source_system_name = 'GWPC'
WHERE h.policy_hk IS NULL
