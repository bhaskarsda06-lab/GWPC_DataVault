SELECT policy_account_contact_hk, load_dts
FROM {{ ref('bridge_policy_account_contact') }}
WHERE policy_account_contact_hk IS NULL
   OR load_dts IS NULL
