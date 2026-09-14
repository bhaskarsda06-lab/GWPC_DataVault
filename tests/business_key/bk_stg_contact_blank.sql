-- Phase 9.2: Business Key Validation - Contact
SELECT publicid
FROM {{ ref('stg_contact') }}
WHERE publicid IS NULL OR TRIM(CAST(publicid AS STRING)) = ''
