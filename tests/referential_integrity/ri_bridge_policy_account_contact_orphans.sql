-- Phase 9.5: Bridge must resolve its Link keys.
SELECT
    b.policy_account_hk,
    b.policy_contact_role_hk
FROM {{ ref('bridge_policy_account_contact') }} b
LEFT JOIN {{ ref('lnk_policy_account') }} pa
  ON b.policy_account_hk = pa.policy_account_hk
LEFT JOIN {{ ref('lnk_policy_contact_role') }} pc
  ON b.policy_contact_role_hk = pc.policy_contact_role_hk
WHERE pa.policy_account_hk IS NULL
   OR pc.policy_contact_role_hk IS NULL
