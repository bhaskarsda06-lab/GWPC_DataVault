SELECT account_hk, hashdiff, COUNT(*) AS cnt
FROM {{ ref('sat_account_core') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
