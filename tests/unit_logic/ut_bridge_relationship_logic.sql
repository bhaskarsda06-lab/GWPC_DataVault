-- Phase 9.8: Bridge rows must represent the Policy-Account and Policy-Contact relationships.
SELECT b.policy_account_contact_hk
FROM {{ ref('bridge_policy_account_contact') }} b
LEFT JOIN {{ ref('lnk_policy_account') }} pa
  ON b.policy_account_hk = pa.policy_account_hk
LEFT JOIN {{ ref('lnk_policy_contact_role') }} pc
  ON b.policy_contact_role_hk = pc.policy_contact_role_hk
WHERE pa.policy_account_hk IS NULL
   OR pc.policy_contact_role_hk IS NULL
