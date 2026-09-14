-- Phase 9.2: Policy Contact Role relationship business-key validation
SELECT policypublicid, contactpublicid, rolecode
FROM {{ ref('stg_policycontactrole') }}
WHERE COALESCE(TRIM(CAST(policypublicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(contactpublicid AS STRING)), '') = ''
   OR COALESCE(TRIM(CAST(rolecode AS STRING)), '') = ''
