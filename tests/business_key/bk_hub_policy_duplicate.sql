-- Phase 9.2: Hub Policy Business Key Uniqueness
SELECT source_system_name, policy_number, term_number, COUNT(*) AS record_count
FROM {{ ref('hub_policy') }}
WHERE COALESCE(TRIM(CAST(policy_number AS STRING)), '') <> ''
GROUP BY source_system_name, policy_number, term_number
HAVING COUNT(*) > 1
