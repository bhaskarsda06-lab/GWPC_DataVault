-- Phase 9.7: Satellite population must not exceed its parent population.
WITH checks AS (
    SELECT 'sat_account_core' model_name, COUNT(*) sat_count,
           (SELECT COUNT(*) FROM {{ ref('hub_account') }} WHERE source_system_name='GWPC') parent_count
    FROM {{ ref('sat_account_core') }}
    UNION ALL
    SELECT 'sat_account_status', COUNT(*),
           (SELECT COUNT(*) FROM {{ ref('hub_account') }} WHERE source_system_name='GWPC')
    FROM {{ ref('sat_account_status') }}
    UNION ALL
    SELECT 'sat_contact_details', COUNT(*),
           (SELECT COUNT(*) FROM {{ ref('hub_contact') }} WHERE source_system_name='GWPC')
    FROM {{ ref('sat_contact_details') }}
    UNION ALL
    SELECT 'sat_policy_details', COUNT(*),
           (SELECT COUNT(*) FROM {{ ref('hub_policy') }} WHERE source_system_name='GWPC')
    FROM {{ ref('sat_policy_details') }}
)
SELECT model_name, sat_count, parent_count, sat_count-parent_count difference
FROM checks
WHERE sat_count < 0 OR sat_count > parent_count
