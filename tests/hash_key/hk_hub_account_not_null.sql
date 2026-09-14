-- Phase 9.3: Hash Key Validation - Account Hub
SELECT account_hk
FROM {{ ref('hub_account') }}
WHERE account_hk IS NULL OR TRIM(CAST(account_hk AS STRING)) = ''
