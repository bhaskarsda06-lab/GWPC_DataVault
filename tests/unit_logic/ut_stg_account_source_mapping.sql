-- Phase 9.8: Staging Account must preserve source business fields.
SELECT s.publicid, s.accountnumber, s.accountname, s.accounttype, s.status
FROM {{ ref('stg_account') }} s
LEFT JOIN {{ source('gwpc', 'pc_account_curr') }} r
  ON s.publicid = r.publicid
WHERE r.publicid IS NULL
   OR COALESCE(s.accountnumber,'') <> COALESCE(r.accountnumber,'')
   OR COALESCE(s.accountname,'') <> COALESCE(r.accountname,'')
   OR COALESCE(s.accounttype,'') <> COALESCE(r.accounttype,'')
   OR COALESCE(s.status,'') <> COALESCE(r.status,'')
