-- Phase 9.4: Hub Contact business-key duplicate detection
SELECT source_system_name, source_system_unique_identifier, COUNT(*) AS duplicate_count
FROM {{ ref('hub_contact') }}
GROUP BY source_system_name, source_system_unique_identifier
HAVING COUNT(*) > 1
