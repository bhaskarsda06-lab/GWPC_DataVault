-- Sentinel proving the production dbt target resolves a production model.
-- It deliberately returns no rows on successful execution.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
HAVING COUNT(*) < 0
