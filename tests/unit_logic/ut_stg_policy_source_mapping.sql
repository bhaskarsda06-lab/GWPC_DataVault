-- Phase 9.8: Staging Policy must preserve source business fields.
SELECT s.publicid, s.policynumber, s.accountpublicid, s.productcode, s.policytype, s.statuscode
FROM {{ ref('stg_policy') }} s
LEFT JOIN {{ source('gwpc', 'pc_policy_curr') }} r
  ON s.publicid = r.publicid
WHERE r.publicid IS NULL
   OR COALESCE(s.policynumber,'') <> COALESCE(r.policynumber,'')
   OR COALESCE(s.accountpublicid,'') <> COALESCE(r.accountpublicid,'')
   OR COALESCE(s.productcode,'') <> COALESCE(r.productcode,'')
   OR COALESCE(s.policytype,'') <> COALESCE(r.policytype,'')
   OR COALESCE(s.statuscode,'') <> COALESCE(r.statuscode,'')
