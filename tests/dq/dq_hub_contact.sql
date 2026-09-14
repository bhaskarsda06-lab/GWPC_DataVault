-- Phase 9.1: Data Quality - Hub Contact
SELECT contact_hk, source_system_unique_identifier, source_system_name
FROM {{ ref('hub_contact') }}
WHERE contact_hk IS NULL
   OR TRIM(CAST(contact_hk AS STRING)) = ''
   OR source_system_unique_identifier IS NULL
   OR TRIM(CAST(source_system_unique_identifier AS STRING)) = ''
   OR source_system_name IS NULL
   OR TRIM(CAST(source_system_name AS STRING)) = ''
