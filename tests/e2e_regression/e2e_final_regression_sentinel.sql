-- Phase 9.9: Final regression sentinel.
-- Returns a row only if a critical model in the integrated chain is empty.
WITH counts AS (
    SELECT 'hub_account' AS object_name, COUNT(*) AS cnt FROM {{ ref('hub_account') }}
    UNION ALL SELECT 'hub_contact', COUNT(*) FROM {{ ref('hub_contact') }}
    UNION ALL SELECT 'hub_policy', COUNT(*) FROM {{ ref('hub_policy') }}
    UNION ALL SELECT 'lnk_policy_account', COUNT(*) FROM {{ ref('lnk_policy_account') }}
    UNION ALL SELECT 'lnk_policy_contact_role', COUNT(*) FROM {{ ref('lnk_policy_contact_role') }}
    UNION ALL SELECT 'bridge_policy_account_contact', COUNT(*) FROM {{ ref('bridge_policy_account_contact') }}
)
SELECT object_name, cnt
FROM counts
WHERE cnt = 0
