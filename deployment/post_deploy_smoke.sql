-- Phase 10 post-deployment smoke test.
-- Run against the deployment target after the dbt deployment.
-- This intentionally checks only critical object existence/population.

SELECT 'hub_account' AS object_name, COUNT(*) AS row_count
FROM {{ ref('hub_account') }}
UNION ALL
SELECT 'hub_contact', COUNT(*) FROM {{ ref('hub_contact') }}
UNION ALL
SELECT 'hub_policy', COUNT(*) FROM {{ ref('hub_policy') }}
UNION ALL
SELECT 'lnk_policy_account', COUNT(*) FROM {{ ref('lnk_policy_account') }}
UNION ALL
SELECT 'lnk_policy_contact_role', COUNT(*) FROM {{ ref('lnk_policy_contact_role') }}
UNION ALL
SELECT 'bridge_policy_account_contact', COUNT(*) FROM {{ ref('bridge_policy_account_contact') }}
