-- Phase 9.4: Contact Details history load timestamp validation
SELECT contact_hk, load_dts
FROM {{ ref('sat_contact_details') }}
WHERE load_dts IS NULL
