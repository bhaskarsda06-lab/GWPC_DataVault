-- Recovery sentinel: production Hub objects must remain queryable.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
HAVING COUNT(*) < 0
