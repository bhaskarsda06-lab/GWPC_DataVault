WITH counts AS (
    SELECT COUNT(*) AS cnt FROM {{ ref('sat_account_core') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('sat_account_status') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('sat_contact_details') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('sat_policy_details') }}
)
SELECT * FROM counts WHERE cnt = 0
