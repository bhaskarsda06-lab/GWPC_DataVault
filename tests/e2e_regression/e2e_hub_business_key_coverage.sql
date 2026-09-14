-- Phase 9.9: Every valid staging business key is represented by its Hub.
WITH expected AS (
    SELECT DISTINCT publicid AS business_key
    FROM {{ ref('stg_account') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
),
actual AS (
    SELECT DISTINCT source_system_unique_identifier AS business_key
    FROM {{ ref('hub_account') }}
    WHERE source_system_name = 'GWPC'
)
SELECT e.business_key
FROM expected e
LEFT JOIN actual a ON e.business_key = a.business_key
WHERE a.business_key IS NULL
