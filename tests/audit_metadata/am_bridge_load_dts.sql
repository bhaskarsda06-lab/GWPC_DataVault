-- Phase 9.6: Bridge audit timestamp validation.
SELECT policy_account_contact_hk, load_dts
FROM {{ ref('bridge_policy_account_contact') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
