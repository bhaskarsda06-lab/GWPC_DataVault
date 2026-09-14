SELECT 'hub_account' AS object_name, account_hk
FROM {{ ref('hub_account') }}
WHERE account_hk IS NULL
UNION ALL
SELECT 'hub_contact', contact_hk
FROM {{ ref('hub_contact') }}
WHERE contact_hk IS NULL
UNION ALL
SELECT 'hub_policy', policy_hk
FROM {{ ref('hub_policy') }}
WHERE policy_hk IS NULL
