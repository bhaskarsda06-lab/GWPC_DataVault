-- Phase 9.9: Critical relationship keys must not be null.
SELECT 'lnk_policy_account' AS object_name
FROM {{ ref('lnk_policy_account') }}
WHERE policy_account_hk IS NULL OR policy_hk IS NULL OR account_hk IS NULL
UNION ALL
SELECT 'lnk_policy_contact_role'
FROM {{ ref('lnk_policy_contact_role') }}
WHERE policy_contact_role_hk IS NULL OR policy_hk IS NULL OR contact_hk IS NULL
UNION ALL
SELECT 'lnk_account_contact'
FROM {{ ref('lnk_account_contact') }}
WHERE account_contact_hk IS NULL OR account_hk IS NULL OR contact_hk IS NULL
