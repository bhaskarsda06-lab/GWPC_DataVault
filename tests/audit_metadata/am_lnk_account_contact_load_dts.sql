-- Phase 9.6: Account-Contact Link audit timestamp validation.
SELECT account_contact_hk, load_dts
FROM {{ ref('lnk_account_contact') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
