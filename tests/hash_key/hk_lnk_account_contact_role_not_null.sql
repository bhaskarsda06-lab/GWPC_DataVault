-- Phase 9.3: Hash Key Validation - Account Contact Role Link
SELECT account_contact_role_hk
FROM {{ ref('lnk_account_contact_role') }}
WHERE account_contact_role_hk IS NULL OR TRIM(CAST(account_contact_role_hk AS STRING)) = ''
