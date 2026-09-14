-- Phase 9.1: Data Quality - Contact Details Satellite
SELECT contact_hk, hashdiff, load_dts
FROM {{ ref('sat_contact_details') }}
WHERE contact_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
