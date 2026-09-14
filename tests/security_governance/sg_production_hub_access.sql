-- Production Hub must be queryable by the dbt production target.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
HAVING COUNT(*) < 0
