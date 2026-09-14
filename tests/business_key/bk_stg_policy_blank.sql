-- Phase 9.2: Business Key Validation - Policy
SELECT publicid, policynumber
FROM {{ ref('stg_policy') }}
WHERE publicid IS NULL
   OR TRIM(CAST(publicid AS STRING)) = ''
   OR policynumber IS NULL
   OR TRIM(CAST(policynumber AS STRING)) = ''
