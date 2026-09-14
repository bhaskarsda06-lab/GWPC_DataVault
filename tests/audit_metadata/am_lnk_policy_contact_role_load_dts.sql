-- Phase 9.6: Policy-Contact-Role Link audit timestamp validation.
SELECT policy_contact_role_hk, load_dts
FROM {{ ref('lnk_policy_contact_role') }}
WHERE load_dts IS NULL OR load_dts > current_timestamp()
