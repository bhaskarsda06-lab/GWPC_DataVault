-- Phase 8.4
-- sat_contact_details -> hub_contact referential integrity.

SELECT
    s.contact_hk
FROM {{ ref('sat_contact_details') }} s
LEFT JOIN {{ ref('hub_contact') }} h
    ON h.contact_hk = s.contact_hk
   AND h.source_system_name = 'GWPC'
WHERE h.contact_hk IS NULL