-- Phase 9.2: Staging Policy Number -> Hub coverage
WITH s AS (
    SELECT DISTINCT TRIM(CAST(policynumber AS STRING)) AS business_key
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(CAST(policynumber AS STRING)), '') <> ''
),
h AS (
    SELECT DISTINCT TRIM(CAST(policy_number AS STRING)) AS business_key
    FROM {{ ref('hub_policy') }}
    WHERE source_system_name = 'GWPC'
      AND COALESCE(TRIM(CAST(policy_number AS STRING)), '') <> ''
)
SELECT s.business_key
FROM s LEFT JOIN h ON s.business_key = h.business_key
WHERE h.business_key IS NULL
