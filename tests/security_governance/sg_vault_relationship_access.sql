WITH objects AS (
    SELECT COUNT(*) AS cnt FROM {{ ref('lnk_account_contact') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_account_contact_role') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_policy_account') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_policy_contact_role') }}
)
SELECT * FROM objects WHERE cnt < 0
