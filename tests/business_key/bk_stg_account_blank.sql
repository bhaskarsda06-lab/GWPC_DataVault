-- Phase 9.2: Business Key Validation - Account
SELECT publicid
FROM {{ ref('stg_account') }}
WHERE publicid IS NULL OR TRIM(CAST(publicid AS STRING)) = ''
