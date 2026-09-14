-- Phase 9.4: Link Policy Contact Role duplicate HK detection
SELECT policy_contact_role_hk, COUNT(*) AS duplicate_count
FROM {{ ref('lnk_policy_contact_role') }}
GROUP BY policy_contact_role_hk
HAVING COUNT(*) > 1
