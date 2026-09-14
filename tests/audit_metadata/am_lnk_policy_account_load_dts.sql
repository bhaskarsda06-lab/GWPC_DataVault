-- Phase 9.6: Policy-Account Link audit timestamp validation.
SELECT policy_account_hk, load_dts
FROM {{ ref('lnk_policy_account') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
