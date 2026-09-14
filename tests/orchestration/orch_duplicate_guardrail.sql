SELECT policy_account_contact_hk, COUNT(*) AS duplicate_count
FROM {{ ref('bridge_policy_account_contact') }}
GROUP BY policy_account_contact_hk
HAVING COUNT(*) > 1
