-- Phase 10.6 Alert Queries
-- READ ONLY.
-- These queries are intended as simple data-integrity alert signals.

-- Alert 1: critical Hub null keys
SELECT 'CRITICAL_HUB_NULL_KEY' AS alert_code,
       COUNT(*) AS failure_count
FROM (
    SELECT account_hk AS hk
    FROM autdbt_vault_prod.autdbtt.hub_account
    WHERE account_hk IS NULL
    UNION ALL
    SELECT contact_hk
    FROM autdbt_vault_prod.autdbtt.hub_contact
    WHERE contact_hk IS NULL
    UNION ALL
    SELECT policy_hk
    FROM autdbt_vault_prod.autdbtt.hub_policy
    WHERE policy_hk IS NULL
) x
HAVING COUNT(*) > 0;

-- Alert 2: bridge integrity
SELECT 'CRITICAL_BRIDGE_NULL_KEY' AS alert_code,
       COUNT(*) AS failure_count
FROM autdbt_vault_prod.autdbtt.bridge_policy_account_contact
WHERE policy_account_hk IS NULL
   OR policy_contact_role_hk IS NULL
   OR policy_account_contact_hk IS NULL
HAVING COUNT(*) > 0;

-- Alert 3: duplicate bridge keys
SELECT 'CRITICAL_BRIDGE_DUPLICATE_KEY' AS alert_code,
       COUNT(*) AS failure_count
FROM (
    SELECT policy_account_contact_hk
    FROM autdbt_vault_prod.autdbtt.bridge_policy_account_contact
    GROUP BY policy_account_contact_hk
    HAVING COUNT(*) > 1
) d
HAVING COUNT(*) > 0;
