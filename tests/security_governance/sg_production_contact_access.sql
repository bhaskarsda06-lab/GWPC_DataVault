SELECT COUNT(*) AS cnt
FROM {{ ref('hub_contact') }}
HAVING COUNT(*) < 0
