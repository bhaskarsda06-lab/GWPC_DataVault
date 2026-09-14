-- Phase 9.5: Bridge must resolve Policy, Account and Contact Hub keys.
SELECT
    b.policy_account_contact_hk,
    b.policy_hk,
    b.account_hk,
    b.contact_hk
FROM {{ ref('bridge_policy_account_contact') }} b
LEFT JOIN {{ ref('hub_policy') }} p
  ON b.policy_hk = p.policy_hk
 AND p.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_account') }} a
  ON b.account_hk = a.account_hk
 AND a.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_contact') }} c
  ON b.contact_hk = c.contact_hk
 AND c.source_system_name = 'GWPC'
WHERE p.policy_hk IS NULL
   OR a.account_hk IS NULL
   OR c.contact_hk IS NULL
