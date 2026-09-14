-- Phase 9.4: Policy Contact Role satellite duplicate history detection
SELECT policy_contact_role_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_policy_contact_role') }}
GROUP BY policy_contact_role_hk, hashdiff
HAVING COUNT(*) > 1
