-- Phase 9.1: Data Quality - Account Contact Role Link
SELECT account_contact_role_hk, account_hk, contact_hk
FROM {{ ref('lnk_account_contact_role') }}
WHERE account_contact_role_hk IS NULL OR account_hk IS NULL OR contact_hk IS NULL
