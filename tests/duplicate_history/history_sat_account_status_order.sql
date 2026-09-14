-- Phase 9.4: Account Status history load timestamp validation
SELECT account_hk, load_dts
FROM {{ ref('sat_account_status') }}
WHERE load_dts IS NULL
