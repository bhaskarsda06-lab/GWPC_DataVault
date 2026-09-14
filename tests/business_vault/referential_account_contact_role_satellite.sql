-- Phase 8.5
SELECT s.account_contact_role_hk
FROM {{ ref('sat_account_contact_role') }} s
LEFT JOIN {{ ref('lnk_account_contact_role') }} l ON s.account_contact_role_hk=l.account_contact_role_hk
WHERE l.account_contact_role_hk IS NULL
