SELECT policy_hk, hashdiff, COUNT(*) AS cnt
FROM {{ ref('sat_policy_details') }}
GROUP BY policy_hk, hashdiff
HAVING COUNT(*) > 1
