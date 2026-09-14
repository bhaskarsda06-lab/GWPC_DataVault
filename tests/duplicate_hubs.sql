SELECT 'hub_account' AS object_name, account_hk AS hk, COUNT(*) AS cnt
FROM {{ ref('hub_account') }}
GROUP BY account_hk HAVING COUNT(*) > 1
UNION ALL
SELECT 'hub_contact', contact_hk, COUNT(*)
FROM {{ ref('hub_contact') }}
GROUP BY contact_hk HAVING COUNT(*) > 1
UNION ALL
SELECT 'hub_policy', policy_hk, COUNT(*)
FROM {{ ref('hub_policy') }}
GROUP BY policy_hk HAVING COUNT(*) > 1
