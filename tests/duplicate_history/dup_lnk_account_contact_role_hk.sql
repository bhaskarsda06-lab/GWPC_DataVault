-- Phase 9.4: Link Account Contact Role duplicate HK detection
SELECT account_contact_role_hk, COUNT(*) AS duplicate_count
FROM {{ ref('lnk_account_contact_role') }}
GROUP BY account_contact_role_hk
HAVING COUNT(*) > 1
