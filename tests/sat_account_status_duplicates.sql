SELECT account_hk, hashdiff, COUNT(*) AS cnt
FROM {{ ref('sat_account_status') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
