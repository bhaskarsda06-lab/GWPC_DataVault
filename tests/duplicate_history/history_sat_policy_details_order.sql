-- Phase 9.4: Policy Details history load timestamp validation
SELECT policy_hk, load_dts
FROM {{ ref('sat_policy_details') }}
WHERE load_dts IS NULL
