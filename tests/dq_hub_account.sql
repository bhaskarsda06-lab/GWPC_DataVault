-- Phase 6 DQ: Account Hub mandatory-key validation.
SELECT
    account_hk,
    source_system_unique_identifier,
    account_number,
    source_system_name
FROM {{ ref('hub_account') }}
WHERE account_hk IS NULL
   OR source_system_unique_identifier IS NULL
   OR account_number IS NULL
   OR source_system_name IS NULL
