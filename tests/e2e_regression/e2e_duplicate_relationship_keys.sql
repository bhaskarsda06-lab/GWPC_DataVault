-- Phase 9.9: End-to-end relationship keys remain unique at their modeled grain.
SELECT 'lnk_policy_account' AS object_name, policy_account_hk AS hk, COUNT(*) AS cnt
FROM {{ ref('lnk_policy_account') }}
GROUP BY policy_account_hk
HAVING COUNT(*) > 1
UNION ALL
SELECT 'lnk_policy_contact_role', policy_contact_role_hk, COUNT(*)
FROM {{ ref('lnk_policy_contact_role') }}
GROUP BY policy_contact_role_hk
HAVING COUNT(*) > 1
UNION ALL
SELECT 'lnk_account_contact', account_contact_hk, COUNT(*)
FROM {{ ref('lnk_account_contact') }}
GROUP BY account_contact_hk
HAVING COUNT(*) > 1
