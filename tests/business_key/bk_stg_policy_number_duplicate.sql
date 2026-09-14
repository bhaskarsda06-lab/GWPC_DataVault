-- Phase 9.2: Duplicate Policy Number Business Keys
SELECT policynumber, COUNT(*) AS record_count
FROM {{ ref('stg_policy') }}
WHERE COALESCE(TRIM(CAST(policynumber AS STRING)), '') <> ''
GROUP BY policynumber
HAVING COUNT(*) > 1
