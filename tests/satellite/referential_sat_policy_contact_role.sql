-- Phase 8.4
-- sat_policy_contact_role -> lnk_policy_contact_role
-- referential integrity.

SELECT
    s.policy_contact_role_hk
FROM {{ ref('sat_policy_contact_role') }} s
LEFT JOIN {{ ref('lnk_policy_contact_role') }} l
    ON l.policy_contact_role_hk =
       s.policy_contact_role_hk
WHERE l.policy_contact_role_hk IS NULL