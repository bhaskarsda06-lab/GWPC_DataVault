SELECT 'sat_account_core' AS satellite_name, s.account_hk AS hk
FROM {{ ref('sat_account_core') }} s
LEFT JOIN {{ ref('hub_account') }} h ON s.account_hk = h.account_hk
WHERE h.account_hk IS NULL
UNION ALL
SELECT 'sat_account_status', s.account_hk
FROM {{ ref('sat_account_status') }} s
LEFT JOIN {{ ref('hub_account') }} h ON s.account_hk = h.account_hk
WHERE h.account_hk IS NULL
UNION ALL
SELECT 'sat_contact_details', s.contact_hk
FROM {{ ref('sat_contact_details') }} s
LEFT JOIN {{ ref('hub_contact') }} h ON s.contact_hk = h.contact_hk
WHERE h.contact_hk IS NULL
UNION ALL
SELECT 'sat_policy_details', s.policy_hk
FROM {{ ref('sat_policy_details') }} s
LEFT JOIN {{ ref('hub_policy') }} h ON s.policy_hk = h.policy_hk
WHERE h.policy_hk IS NULL
