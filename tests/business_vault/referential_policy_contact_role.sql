-- Phase 8.5
SELECT l.policy_contact_role_hk,l.policy_hk,l.contact_hk
FROM {{ ref('lnk_policy_contact_role') }} l
LEFT JOIN {{ ref('hub_policy') }} p ON l.policy_hk=p.policy_hk AND p.source_system_name='GWPC'
LEFT JOIN {{ ref('hub_contact') }} c ON l.contact_hk=c.contact_hk AND c.source_system_name='GWPC'
WHERE p.policy_hk IS NULL OR c.contact_hk IS NULL
