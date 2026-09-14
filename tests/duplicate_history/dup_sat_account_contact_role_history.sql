-- Phase 9.4: Account Contact Role satellite duplicate history detection
SELECT account_contact_role_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_account_contact_role') }}
GROUP BY account_contact_role_hk, hashdiff
HAVING COUNT(*) > 1
