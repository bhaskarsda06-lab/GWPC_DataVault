-- Phase 8.5
SELECT s.policy_contact_role_hk
FROM {{ ref('sat_policy_contact_role') }} s
LEFT JOIN {{ ref('lnk_policy_contact_role') }} l ON s.policy_contact_role_hk=l.policy_contact_role_hk
WHERE l.policy_contact_role_hk IS NULL
