-- Phase 9.6: Hubs must carry the expected source-system audit value.
SELECT account_hk, source_system_name
FROM {{ ref('hub_account') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
UNION ALL
SELECT contact_hk, source_system_name
FROM {{ ref('hub_contact') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
UNION ALL
SELECT policy_hk, source_system_name
FROM {{ ref('hub_policy') }}
WHERE source_system_name IS NULL OR TRIM(source_system_name) <> 'GWPC'
