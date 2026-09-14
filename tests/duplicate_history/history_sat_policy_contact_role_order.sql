-- Phase 9.4: Policy Contact Role history load timestamp validation
SELECT policy_contact_role_hk, load_dts
FROM {{ ref('sat_policy_contact_role') }}
WHERE load_dts IS NULL
