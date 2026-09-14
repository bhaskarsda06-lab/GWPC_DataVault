-- Fails if any critical Hub is empty.
WITH counts AS (
    SELECT COUNT(*) AS cnt FROM {{ ref('hub_account') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('hub_contact') }}
    UNION ALL
    SELECT COUNT(*) FROM {{ ref('hub_policy') }}
)
SELECT * FROM counts WHERE cnt = 0
