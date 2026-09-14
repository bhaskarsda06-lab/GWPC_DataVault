-- Phase 9.3: Recalculate Account Contact Link HK.
SELECT l.account_contact_hk, x.expected_hk
FROM {{ ref('lnk_account_contact') }} l
JOIN (
    SELECT DISTINCT
        accountpublicid, contactpublicid,
        sha2(concat_ws('|', accountpublicid, contactpublicid, 'GWPC'), 256) expected_hk
    FROM {{ ref('stg_accountcontact') }}
    WHERE COALESCE(TRIM(accountpublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
) x
 ON l.accountpublicid=x.accountpublicid AND l.contactpublicid=x.contactpublicid
WHERE l.account_contact_hk <> x.expected_hk
