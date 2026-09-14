-- Phase 9.9: Business Vault links resolve to their required parent Hubs.
WITH orphans AS (
    SELECT l.policy_hk AS hk
    FROM {{ ref('lnk_policy_account') }} l
    LEFT JOIN {{ ref('hub_policy') }} h ON l.policy_hk = h.policy_hk
    WHERE h.policy_hk IS NULL

    UNION ALL

    SELECT l.account_hk
    FROM {{ ref('lnk_policy_account') }} l
    LEFT JOIN {{ ref('hub_account') }} h ON l.account_hk = h.account_hk
    WHERE h.account_hk IS NULL

    UNION ALL

    SELECT l.policy_hk
    FROM {{ ref('lnk_policy_contact_role') }} l
    LEFT JOIN {{ ref('hub_policy') }} h ON l.policy_hk = h.policy_hk
    WHERE h.policy_hk IS NULL

    UNION ALL

    SELECT l.contact_hk
    FROM {{ ref('lnk_policy_contact_role') }} l
    LEFT JOIN {{ ref('hub_contact') }} h ON l.contact_hk = h.contact_hk
    WHERE h.contact_hk IS NULL
)
SELECT hk FROM orphans
