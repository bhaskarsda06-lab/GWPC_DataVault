-- Phase 9.9: Account -> Contact chain is complete.
SELECT l.account_hk, l.contact_hk
FROM {{ ref('lnk_account_contact') }} l
LEFT JOIN {{ ref('hub_account') }} a ON l.account_hk = a.account_hk
LEFT JOIN {{ ref('hub_contact') }} c ON l.contact_hk = c.contact_hk
WHERE a.account_hk IS NULL
   OR c.contact_hk IS NULL
