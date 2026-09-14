-- Phase 9.4: Hub Account business-key duplicate detection
SELECT source_system_name, source_system_unique_identifier, COUNT(*) AS duplicate_count
FROM {{ ref('hub_account') }}
GROUP BY source_system_name, source_system_unique_identifier
HAVING COUNT(*) > 1
