-- Phase 9.8: Account-Contact Link must represent existing staging relationships.
SELECT l.account_contact_hk, l.accountpublicid, l.contactpublicid
FROM {{ ref('lnk_account_contact') }} l
LEFT JOIN {{ ref('stg_accountcontact') }} s
  ON l.accountpublicid = s.accountpublicid
 AND l.contactpublicid = s.contactpublicid
WHERE s.accountpublicid IS NULL
