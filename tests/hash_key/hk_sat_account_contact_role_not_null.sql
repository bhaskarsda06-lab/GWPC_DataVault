-- Phase 9.3: Hash Key Validation - Account Contact Role Satellite
SELECT account_contact_role_hk
FROM {{ ref('sat_account_contact_role') }}
WHERE account_contact_role_hk IS NULL OR TRIM(CAST(account_contact_role_hk AS STRING)) = ''
