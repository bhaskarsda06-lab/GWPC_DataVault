-- Phase 9.1: Data Quality - Hub Account
SELECT account_hk, source_system_unique_identifier, source_system_name
FROM {{ ref('hub_account') }}
WHERE account_hk IS NULL
   OR TRIM(CAST(account_hk AS STRING)) = ''
   OR source_system_unique_identifier IS NULL
   OR TRIM(CAST(source_system_unique_identifier AS STRING)) = ''
   OR source_system_name IS NULL
   OR TRIM(CAST(source_system_name AS STRING)) = ''
