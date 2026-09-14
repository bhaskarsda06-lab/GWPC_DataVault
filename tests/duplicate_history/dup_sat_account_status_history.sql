-- Phase 9.4: Account Status satellite duplicate history detection
SELECT account_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_account_status') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
