-- Phase 9.4: Contact Details satellite duplicate history detection
SELECT contact_hk, hashdiff, COUNT(*) AS duplicate_count
FROM {{ ref('sat_contact_details') }}
GROUP BY contact_hk, hashdiff
HAVING COUNT(*) > 1
