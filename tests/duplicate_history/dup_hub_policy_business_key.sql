-- Phase 9.4: Hub Policy business-key duplicate detection
SELECT source_system_name, policy_number, term_number, COUNT(*) AS duplicate_count
FROM {{ ref('hub_policy') }}
GROUP BY source_system_name, policy_number, term_number
HAVING COUNT(*) > 1
