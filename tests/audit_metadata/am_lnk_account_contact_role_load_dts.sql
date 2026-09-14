-- Phase 9.6: Account-Contact-Role Link audit timestamp validation.
SELECT account_contact_role_hk, load_dts
FROM {{ ref('lnk_account_contact_role') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
