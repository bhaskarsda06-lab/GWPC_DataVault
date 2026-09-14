-- Phase 9.8: Staging Contact must preserve source business fields.
SELECT s.publicid, s.firstname, s.middlename, s.lastname, s.email, s.phone
FROM {{ ref('stg_contact') }} s
LEFT JOIN {{ source('gwpc', 'pc_contact_curr') }} r
  ON s.publicid = r.publicid
WHERE r.publicid IS NULL
   OR COALESCE(s.firstname,'') <> COALESCE(r.firstname,'')
   OR COALESCE(s.middlename,'') <> COALESCE(r.middlename,'')
   OR COALESCE(s.lastname,'') <> COALESCE(r.lastname,'')
   OR COALESCE(s.email,'') <> COALESCE(r.email,'')
   OR COALESCE(s.phone,'') <> COALESCE(r.phone,'')
