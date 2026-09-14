-- Phase 9.2: Account Contact relationship business-key validation
SELECT accountpublicid, contactpublicid
FROM {{ ref('stg_accountcontact') }}
WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(contactpublicid AS STRING)), '') = ''
