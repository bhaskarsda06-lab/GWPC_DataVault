-- Phase 9.1: Data Quality - Hub Policy
SELECT policy_hk, policy_number, term_number, source_system_name
FROM {{ ref('hub_policy') }}
WHERE policy_hk IS NULL
   OR TRIM(CAST(policy_hk AS STRING)) = ''
   OR policy_number IS NULL
   OR TRIM(CAST(policy_number AS STRING)) = ''
   OR term_number IS NULL
   OR source_system_name IS NULL
   OR TRIM(CAST(source_system_name AS STRING)) = ''
