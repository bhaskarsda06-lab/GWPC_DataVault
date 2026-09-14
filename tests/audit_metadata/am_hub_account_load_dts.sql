-- Phase 9.6: Hub Account load timestamp must be populated and not future-dated.
SELECT account_hk, load_dts
FROM {{ ref('hub_account') }}
WHERE load_dts IS NULL
   OR load_dts > current_timestamp()
