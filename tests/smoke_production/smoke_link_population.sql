-- Fails if a critical relationship object is empty.
WITH counts AS (
    SELECT COUNT(*) AS cnt FROM {{ ref('lnk_account_contact') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_account_contact_role') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_policy_account') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('lnk_policy_contact_role') }}
)
SELECT * FROM counts WHERE cnt = 0
