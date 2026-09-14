SELECT 'lnk_account_contact' AS object_name, load_dts
FROM {{ ref('lnk_account_contact') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'lnk_account_contact_role', load_dts
FROM {{ ref('lnk_account_contact_role') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'lnk_policy_account', load_dts
FROM {{ ref('lnk_policy_account') }}
WHERE load_dts IS NULL
UNION ALL
SELECT 'lnk_policy_contact_role', load_dts
FROM {{ ref('lnk_policy_contact_role') }}
WHERE load_dts IS NULL
