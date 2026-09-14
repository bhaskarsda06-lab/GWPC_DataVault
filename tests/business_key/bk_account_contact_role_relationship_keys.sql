-- Phase 9.2: Account Contact Role relationship business-key validation
SELECT accountpublicid, contactpublicid, rolecode
FROM {{ ref('stg_accountcontactrole') }}
WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(contactpublicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(rolecode AS STRING)), '') = ''
