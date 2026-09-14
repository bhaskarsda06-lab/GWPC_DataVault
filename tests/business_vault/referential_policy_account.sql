-- Phase 8.5
SELECT l.policy_account_hk,l.policy_hk,l.account_hk
FROM {{ ref('lnk_policy_account') }} l
LEFT JOIN {{ ref('hub_policy') }} p ON l.policy_hk=p.policy_hk AND p.source_system_name='GWPC'
LEFT JOIN {{ ref('hub_account') }} a ON l.account_hk=a.account_hk AND a.source_system_name='GWPC'
WHERE p.policy_hk IS NULL OR a.account_hk IS NULL
