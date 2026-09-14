-- Phase 9.2: Duplicate Contact Business Keys
SELECT publicid, COUNT(*) AS record_count
FROM {{ ref('stg_contact') }}
WHERE COALESCE(TRIM(CAST(publicid AS STRING)), '') <> ''
GROUP BY publicid
HAVING COUNT(*) > 1
