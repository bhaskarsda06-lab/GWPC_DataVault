-- Phase 9.1: Data Quality - Policy Account Link
SELECT policy_account_hk, policy_hk, account_hk
FROM {{ ref('lnk_policy_account') }}
WHERE policy_account_hk IS NULL OR policy_hk IS NULL OR account_hk IS NULL
