-- Phase 9.4: Account Contact Role history load timestamp validation
SELECT account_contact_role_hk, load_dts
FROM {{ ref('sat_account_contact_role') }}
WHERE load_dts IS NULL
