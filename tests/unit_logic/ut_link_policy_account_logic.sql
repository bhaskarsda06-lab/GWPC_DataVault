-- Phase 9.8: Policy-Account Link must represent staging Policy relationships.
{{ config(severity='warn') }}
SELECT l.policy_account_hk, l.policypublicid, l.accountpublicid
FROM {{ ref('lnk_policy_account') }} l
LEFT JOIN {{ ref('stg_policy') }} s
  ON l.policypublicid = s.publicid
 AND l.accountpublicid = s.accountpublicid
WHERE s.publicid IS NULL
