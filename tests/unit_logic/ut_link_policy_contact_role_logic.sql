-- Phase 9.8: Policy-Contact-Role Link must represent staging relationships.
SELECT l.policy_contact_role_hk, l.policypublicid, l.contactpublicid, l.rolecode
FROM {{ ref('lnk_policy_contact_role') }} l
LEFT JOIN {{ ref('stg_policycontactrole') }} s
  ON l.policypublicid = s.policypublicid
 AND l.contactpublicid = s.contactpublicid
 AND l.rolecode = s.rolecode
WHERE s.policypublicid IS NULL
