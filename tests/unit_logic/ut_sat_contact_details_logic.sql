-- Phase 9.8: Contact Details satellite must map to the corresponding Hub Contact.
SELECT s.contact_hk
FROM {{ ref('sat_contact_details') }} s
LEFT JOIN {{ ref('hub_contact') }} h
  ON s.contact_hk = h.contact_hk
 AND h.source_system_name = 'GWPC'
WHERE h.contact_hk IS NULL
