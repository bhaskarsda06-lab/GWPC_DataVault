-- Phase 8.3
-- Policy Account Link -> Hub referential integrity.

SELECT
    l.policy_account_hk,
    l.policypublicid,
    l.accountpublicid
FROM {{ ref('lnk_policy_account') }} l
LEFT JOIN {{ ref('hub_policy') }} p
    ON p.policy_hk = l.policy_hk
   AND p.source_system_name = 'GWPC'
LEFT JOIN {{ ref('hub_account') }} a
    ON a.account_hk = l.account_hk
   AND a.source_system_name = 'GWPC'
WHERE p.policy_hk IS NULL
   OR a.account_hk IS NULL