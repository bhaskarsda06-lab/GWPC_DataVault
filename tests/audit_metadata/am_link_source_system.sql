-- Phase 9.6: Business Vault links must carry GWPC source-system context.
SELECT 'lnk_account_contact' AS model_name, account_contact_hk AS link_hk, source_system_name
FROM {{ ref('lnk_account_contact') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
UNION ALL
SELECT 'lnk_account_contact_role', account_contact_role_hk, source_system_name
FROM {{ ref('lnk_account_contact_role') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
UNION ALL
SELECT 'lnk_policy_account', policy_account_hk, source_system_name
FROM {{ ref('lnk_policy_account') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
UNION ALL
SELECT 'lnk_policy_contact_role', policy_contact_role_hk, source_system_name
FROM {{ ref('lnk_policy_contact_role') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
