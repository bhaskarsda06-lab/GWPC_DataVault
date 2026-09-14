-- Phase 9.9: Policy -> Account chain is complete from Policy Hub through Link to Account Hub.
SELECT l.policy_hk, l.account_hk
FROM {{ ref('lnk_policy_account') }} l
LEFT JOIN {{ ref('hub_policy') }} p ON l.policy_hk = p.policy_hk
LEFT JOIN {{ ref('hub_account') }} a ON l.account_hk = a.account_hk
WHERE p.policy_hk IS NULL
   OR a.account_hk IS NULL
