-- Phase 9.9: Every valid staging Policy number is represented by Policy Hub.
WITH expected AS (
    SELECT DISTINCT policynumber AS business_key
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(policynumber),'') <> ''
),
actual AS (
    SELECT DISTINCT policy_number AS business_key
    FROM {{ ref('hub_policy') }}
    WHERE source_system_name = 'GWPC'
)
SELECT e.business_key
FROM expected e
LEFT JOIN actual a ON e.business_key = a.business_key
WHERE a.business_key IS NULL
