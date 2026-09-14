-- Phase 8.3
-- Account Contact Link -> Hub referential integrity.

SELECT
    l.account_contact_hk,
    l.accountpublicid,
    l.contactpublicid
FROM {{ ref('lnk_account_contact') }} l
LEFT JOIN {{ ref('hub_account') }} a
    ON a.account_hk = l.account_hk
   AND a.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_contact') }} c
    ON c.contact_hk = l.contact_hk
   AND c.source_system_name = 'GWPC'
WHERE a.account_hk IS NULL
   OR c.contact_hk IS NULL