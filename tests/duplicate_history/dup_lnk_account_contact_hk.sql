-- Phase 9.4: Link Account Contact duplicate HK detection
SELECT account_contact_hk, COUNT(*) AS duplicate_count
FROM {{ ref('lnk_account_contact') }}
GROUP BY account_contact_hk
HAVING COUNT(*) > 1
