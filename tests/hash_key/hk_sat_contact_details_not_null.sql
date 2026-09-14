-- Phase 9.3: Hash Key Validation - Contact Details Satellite
SELECT contact_hk
FROM {{ ref('sat_contact_details') }}
WHERE contact_hk IS NULL OR TRIM(CAST(contact_hk AS STRING)) = ''
