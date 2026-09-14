-- Phase 9.3: Recalculate Account Contact Role Link HK.
SELECT l.account_contact_role_hk, x.expected_hk
FROM {{ ref('lnk_account_contact_role') }} l
JOIN (
    SELECT DISTINCT
        accountpublicid, contactpublicid, rolecode,
        sha2(concat_ws('|', accountpublicid, contactpublicid, rolecode, 'GWPC'), 256) expected_hk
    FROM {{ ref('stg_accountcontactrole') }}
    WHERE COALESCE(TRIM(accountpublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
      AND COALESCE(TRIM(rolecode),'') <> ''
) x
 ON l.accountpublicid=x.accountpublicid AND l.contactpublicid=x.contactpublicid AND l.rolecode=x.rolecode
WHERE l.account_contact_role_hk <> x.expected_hk
