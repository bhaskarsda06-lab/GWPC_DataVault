-- Phase 9.4: Account Core satellite duplicate history detection
SELECT account_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_account_core') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
