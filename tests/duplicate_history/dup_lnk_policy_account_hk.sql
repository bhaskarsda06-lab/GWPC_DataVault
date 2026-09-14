-- Phase 9.4: Link Policy Account duplicate HK detection
SELECT policy_account_hk, COUNT(*) AS duplicate_count
FROM {{ ref('lnk_policy_account') }}
GROUP BY policy_account_hk
HAVING COUNT(*) > 1
