SELECT COUNT(*) AS cnt
FROM {{ ref('bridge_policy_account_contact') }}
HAVING COUNT(*) < 0
