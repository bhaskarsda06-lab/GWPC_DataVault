-- Fails if core audit timestamps are null.
SELECT 'hub_account' AS object_name, load_dts
FROM {{ ref('hub_account') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'hub_contact', load_dts
FROM {{ ref('hub_contact') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'hub_policy', load_dts
FROM {{ ref('hub_policy') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'sat_account_core', load_dts
FROM {{ ref('sat_account_core') }}
WHERE load_dts IS NULL
