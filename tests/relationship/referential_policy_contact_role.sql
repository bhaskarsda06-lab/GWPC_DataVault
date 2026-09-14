-- Phase 8.3
-- Policy Contact Role Link -> Hub referential integrity.

SELECT
    l.policy_contact_role_hk,
    l.policypublicid,
    l.contactpublicid,
    l.rolecode
FROM {{ ref('lnk_policy_contact_role') }} l
LEFT JOIN {{ ref('hub_policy') }} p
    ON p.policy_hk = l.policy_hk
   AND p.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_contact') }} c
    ON c.contact_hk = l.contact_hk
   AND c.source_system_name = 'GWPC'
WHERE p.policy_hk IS NULL
   OR c.contact_hk IS NULL