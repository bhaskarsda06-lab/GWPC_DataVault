-- Phase 9.8: Contact Hub must map its business key to staging Contact.
SELECT h.contact_hk, h.source_system_unique_identifier, s.publicid
FROM {{ ref('hub_contact') }} h
LEFT JOIN {{ ref('stg_contact') }} s
  ON h.source_system_unique_identifier = s.publicid
WHERE h.source_system_name = 'GWPC'
  AND (s.publicid IS NULL OR h.source_system_unique_identifier <> s.publicid)
