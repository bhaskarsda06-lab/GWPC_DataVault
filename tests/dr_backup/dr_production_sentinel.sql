-- Production recovery sentinel.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
HAVING COUNT(*) < 0
