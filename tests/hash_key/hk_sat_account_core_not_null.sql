-- Phase 9.3: Hash Key Validation - Account Core Satellite
SELECT account_hk
FROM {{ ref('sat_account_core') }}
WHERE account_hk IS NULL OR TRIM(CAST(account_hk AS STRING)) = ''
