-- Phase 8.5
SELECT b.policy_account_contact_hk,b.policy_account_hk,b.policy_contact_role_hk
FROM {{ ref('bridge_policy_account_contact') }} b
LEFT JOIN {{ ref('lnk_policy_account') }} pa ON b.policy_account_hk=pa.policy_account_hk
LEFT JOIN {{ ref('lnk_policy_contact_role') }} pcr ON b.policy_contact_role_hk=pcr.policy_contact_role_hk
LEFT JOIN {{ ref('hub_policy') }} hp ON pcr.policy_hk=hp.policy_hk AND hp.source_system_name='GWPC'
LEFT JOIN {{ ref('hub_account') }} ha ON pa.account_hk=ha.account_hk AND ha.source_system_name='GWPC'
LEFT JOIN {{ ref('hub_contact') }} hc ON pcr.contact_hk=hc.contact_hk AND hc.source_system_name='GWPC'
WHERE pa.policy_account_hk IS NULL OR pcr.policy_contact_role_hk IS NULL OR hp.policy_hk IS NULL OR ha.account_hk IS NULL OR hc.contact_hk IS NULL
