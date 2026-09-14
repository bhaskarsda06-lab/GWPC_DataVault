-- Phase 9.2: Policy Account relationship business-key validation
SELECT publicid, policynumber, accountpublicid
FROM {{ ref('stg_policy') }}
WHERE COALESCE(TRIM(CAST(publicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(policynumber AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(accountpublicid AS STRING)), '') = ''
