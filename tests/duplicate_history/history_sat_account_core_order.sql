-- Phase 9.4: Account Core history load timestamp validation
SELECT account_hk, load_dts
FROM {{ ref('sat_account_core') }}
WHERE load_dts IS NULL
