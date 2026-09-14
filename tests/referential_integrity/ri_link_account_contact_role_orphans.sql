-- Phase 9.5: Account-Contact-Role link must resolve to both Hubs.
SELECT l.account_contact_role_hk, l.account_hk, l.contact_hk
FROM {{ ref('lnk_account_contact_role') }} l
LEFT JOIN {{ ref('hub_account') }} a
  ON l.account_hk = a.account_hk
 AND a.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_contact') }} c
  ON l.contact_hk = c.contact_hk
 AND c.source_system_name = 'GWPC'
WHERE a.account_hk IS NULL OR c.contact_hk IS NULL
