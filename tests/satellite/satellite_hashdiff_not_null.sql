-- Phase 8.4
-- Every satellite record must have a hashdiff.

SELECT
    satellite_name,
    invalid_count
FROM (

    SELECT
        'sat_account_core' AS satellite_name,
        COUNT(*) AS invalid_count
    FROM {{ ref('sat_account_core') }}
    WHERE hashdiff IS NULL

    UNION ALL

    SELECT
        'sat_account_status',
        COUNT(*)
    FROM {{ ref('sat_account_status') }}
    WHERE hashdiff IS NULL

    UNION ALL

    SELECT
        'sat_contact_details',
        COUNT(*)
    FROM {{ ref('sat_contact_details') }}
    WHERE hashdiff IS NULL

    UNION ALL

    SELECT
        'sat_policy_details',
        COUNT(*)
    FROM {{ ref('sat_policy_details') }}
    WHERE hashdiff IS NULL

    UNION ALL

    SELECT
        'sat_account_contact_role',
        COUNT(*)
    FROM {{ ref('sat_account_contact_role') }}
    WHERE hashdiff IS NULL

    UNION ALL

    SELECT
        'sat_policy_contact_role',
        COUNT(*)
    FROM {{ ref('sat_policy_contact_role') }}
    WHERE hashdiff IS NULL

)
WHERE invalid_count > 0