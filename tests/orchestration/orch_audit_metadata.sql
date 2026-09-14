SELECT 'hub_account' AS object_name
FROM {{ ref('hub_account') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'hub_contact'
FROM {{ ref('hub_contact') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'hub_policy'
FROM {{ ref('hub_policy') }}
WHERE load_dts IS NULL
