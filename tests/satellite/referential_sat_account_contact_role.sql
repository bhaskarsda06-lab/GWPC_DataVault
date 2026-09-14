-- Phase 8.4
-- sat_account_contact_role -> lnk_account_contact_role
-- referential integrity.

SELECT
    s.account_contact_role_hk
FROM {{ ref('sat_account_contact_role') }} s
LEFT JOIN {{ ref('lnk_account_contact_role') }} l
    ON l.account_contact_role_hk =
       s.account_contact_role_hk
WHERE l.account_contact_role_hk IS NULL