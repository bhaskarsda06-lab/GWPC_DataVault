-- Evidence sentinel: core production object is queryable.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
HAVING COUNT(*) < 0
