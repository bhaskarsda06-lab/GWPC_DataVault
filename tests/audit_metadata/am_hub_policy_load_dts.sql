-- Phase 9.6: Hub Policy load timestamp must be populated and not future-dated.
SELECT policy_hk, load_dts
FROM {{ ref('hub_policy') }}
WHERE load_dts IS NULL
   OR load_dts > current_timestamp()
