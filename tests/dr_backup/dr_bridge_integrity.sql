SELECT policy_account_contact_hk
FROM {{ ref('bridge_policy_account_contact') }}
WHERE policy_account_contact_hk IS NULL
   OR policy_account_hk IS NULL
   OR policy_contact_role_hk IS NULL
