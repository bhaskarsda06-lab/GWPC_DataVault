-- Phase 9.4: Policy Details satellite duplicate history detection
SELECT policy_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_policy_details') }}
GROUP BY policy_hk, hashdiff
HAVING COUNT(*) > 1
