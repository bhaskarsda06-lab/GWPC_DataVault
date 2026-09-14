-- Phase 9.2: Staging Account BK -> Hub coverage
WITH s AS (
    SELECT DISTINCT TRIM(CAST(publicid AS STRING)) AS business_key
    FROM {{ ref('stg_account') }}
    WHERE COALESCE(TRIM(CAST(publicid AS STRING)), '') <> ''
),
h AS (
    SELECT DISTINCT TRIM(CAST(source_system_unique_identifier AS STRING)) AS business_key
    FROM {{ ref('hub_account') }}
    WHERE source_system_name = 'GWPC'
      AND COALESCE(TRIM(CAST(source_system_unique_identifier AS STRING)), '') <> ''
)
SELECT s.business_key
FROM s LEFT JOIN h ON s.business_key = h.business_key
WHERE h.business_key IS NULL
