-- Phase 9.1: Data Quality - Account Contact Link
SELECT account_contact_hk, account_hk, contact_hk
FROM {{ ref('lnk_account_contact') }}
WHERE account_contact_hk IS NULL OR account_hk IS NULL OR contact_hk IS NULL
