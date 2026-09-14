-- Phase 9.3: Hash Key Validation - Policy Account Link
SELECT policy_account_hk
FROM {{ ref('lnk_policy_account') }}
WHERE policy_account_hk IS NULL OR TRIM(CAST(policy_account_hk AS STRING)) = ''
