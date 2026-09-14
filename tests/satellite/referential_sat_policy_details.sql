-- Phase 8.4
-- sat_policy_details -> hub_policy referential integrity.

SELECT
    s.policy_hk
FROM {{ ref('sat_policy_details') }} s
LEFT JOIN {{ ref('hub_policy') }} h
    ON h.policy_hk = s.policy_hk
   AND h.source_system_name = 'GWPC'
WHERE h.policy_hk IS NULL