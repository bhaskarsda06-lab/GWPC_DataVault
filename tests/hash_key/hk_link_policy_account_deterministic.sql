-- Phase 9.3: Recalculate Policy Account Link HK.
SELECT l.policy_account_hk, x.expected_hk
FROM {{ ref('lnk_policy_account') }} l
JOIN (
    SELECT DISTINCT
        publicid, accountpublicid,
        sha2(concat_ws('|', publicid, accountpublicid, 'GWPC'), 256) expected_hk
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
      AND COALESCE(TRIM(accountpublicid),'') <> ''
) x
 ON l.policypublicid=x.publicid AND l.accountpublicid=x.accountpublicid
WHERE l.policy_account_hk <> x.expected_hk
