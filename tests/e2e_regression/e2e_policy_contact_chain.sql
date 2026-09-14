-- Phase 9.9: Policy -> Contact chain is complete from Policy-Contact-Role Link.
SELECT l.policy_hk, l.contact_hk
FROM {{ ref('lnk_policy_contact_role') }} l
LEFT JOIN {{ ref('hub_policy') }} p ON l.policy_hk = p.policy_hk
LEFT JOIN {{ ref('hub_contact') }} c ON l.contact_hk = c.contact_hk
WHERE p.policy_hk IS NULL
   OR c.contact_hk IS NULL
