SELECT COUNT(*) AS cnt
FROM {{ ref('hub_policy') }}
HAVING COUNT(*) < 0
