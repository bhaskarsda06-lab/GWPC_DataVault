-- Phase 9.2: Hub Contact Business Key Uniqueness
SELECT source_system_name, source_system_unique_identifier, COUNT(*) AS record_count
FROM {{ ref('hub_contact') }}
WHERE COALESCE(TRIM(CAST(source_system_unique_identifier AS STRING)), '') <> ''
GROUP BY source_system_name, source_system_unique_identifier
HAVING COUNT(*) > 1
