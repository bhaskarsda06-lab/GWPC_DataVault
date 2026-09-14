-- Phase 8.4
-- Detect duplicate satellite history records.
-- A parent HK + hashdiff combination should occur only once.

WITH satellite_duplicates AS (

    SELECT
        'sat_account_core' AS satellite_name,
        CAST(account_hk AS STRING) AS parent_hk,
        CAST(hashdiff AS STRING) AS hashdiff,
        COUNT(*) AS record_count
    FROM {{ ref('sat_account_core') }}
    GROUP BY account_hk, hashdiff
    HAVING COUNT(*) > 1

    UNION ALL

    SELECT
        'sat_account_status',
        CAST(account_hk AS STRING),
        CAST(hashdiff AS STRING),
        COUNT(*)
    FROM {{ ref('sat_account_status') }}
    GROUP BY account_hk, hashdiff
    HAVING COUNT(*) > 1

    UNION ALL

    SELECT
        'sat_contact_details',
        CAST(contact_hk AS STRING),
        CAST(hashdiff AS STRING),
        COUNT(*)
    FROM {{ ref('sat_contact_details') }}
    GROUP BY contact_hk, hashdiff
    HAVING COUNT(*) > 1

    UNION ALL

    SELECT
        'sat_policy_details',
        CAST(policy_hk AS STRING),
        CAST(hashdiff AS STRING),
        COUNT(*)
    FROM {{ ref('sat_policy_details') }}
    GROUP BY policy_hk, hashdiff
    HAVING COUNT(*) > 1

    UNION ALL

    SELECT
        'sat_account_contact_role',
        CAST(account_contact_role_hk AS STRING),
        CAST(hashdiff AS STRING),
        COUNT(*)
    FROM {{ ref('sat_account_contact_role') }}
    GROUP BY account_contact_role_hk, hashdiff
    HAVING COUNT(*) > 1

    UNION ALL

    SELECT
        'sat_policy_contact_role',
        CAST(policy_contact_role_hk AS STRING),
        CAST(hashdiff AS STRING),
        COUNT(*)
    FROM {{ ref('sat_policy_contact_role') }}
    GROUP BY policy_contact_role_hk, hashdiff
    HAVING COUNT(*) > 1
)

SELECT *
FROM satellite_duplicates