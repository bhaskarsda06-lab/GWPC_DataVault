SELECT 'sat_account_core' AS object_name, account_hk, hashdiff, COUNT(*) AS cnt
FROM {{ ref('sat_account_core') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
UNION ALL
SELECT 'sat_account_status', account_hk, hashdiff, COUNT(*)
FROM {{ ref('sat_account_status') }}
GROUP BY account_hk, hashdiff
HAVING COUNT(*) > 1
UNION ALL
SELECT 'sat_contact_details', contact_hk, hashdiff, COUNT(*)
FROM {{ ref('sat_contact_details') }}
GROUP BY contact_hk, hashdiff
HAVING COUNT(*) > 1
UNION ALL
SELECT 'sat_policy_details', policy_hk, hashdiff, COUNT(*)
FROM {{ ref('sat_policy_details') }}
GROUP BY policy_hk, hashdiff
HAVING COUNT(*) > 1
