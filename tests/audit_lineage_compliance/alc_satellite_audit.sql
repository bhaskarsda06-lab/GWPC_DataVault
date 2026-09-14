SELECT 'sat_account_core' AS object_name, load_dts
FROM {{ ref('sat_account_core') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'sat_account_status', load_dts
FROM {{ ref('sat_account_status') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'sat_contact_details', load_dts
FROM {{ ref('sat_contact_details') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'sat_policy_details', load_dts
FROM {{ ref('sat_policy_details') }}
WHERE load_dts IS NULL
