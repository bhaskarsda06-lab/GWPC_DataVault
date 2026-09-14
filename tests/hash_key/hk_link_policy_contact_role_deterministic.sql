-- Phase 9.3: Recalculate Policy Contact Role Link HK.
SELECT l.policy_contact_role_hk, x.expected_hk
FROM {{ ref('lnk_policy_contact_role') }} l
JOIN (
    SELECT DISTINCT
        policypublicid, contactpublicid, rolecode,
        sha2(concat_ws('|', policypublicid, contactpublicid, rolecode, 'GWPC'), 256) expected_hk
    FROM {{ ref('stg_policycontactrole') }}
    WHERE COALESCE(TRIM(policypublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
      AND COALESCE(TRIM(rolecode),'') <> ''
) x
 ON l.policypublicid=x.policypublicid AND l.contactpublicid=x.contactpublicid AND l.rolecode=x.rolecode
WHERE l.policy_contact_role_hk <> x.expected_hk
