-- Phase 9.3: Hash Key Validation - Account Contact Link
SELECT account_contact_hk
FROM {{ ref('lnk_account_contact') }}
WHERE account_contact_hk IS NULL OR TRIM(CAST(account_contact_hk AS STRING)) = ''
