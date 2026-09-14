-- Phase 9.8: Account Hub must map its business key to staging Account.
SELECT h.account_hk, h.source_system_unique_identifier, s.publicid
FROM {{ ref('hub_account') }} h
LEFT JOIN {{ ref('stg_account') }} s
  ON h.source_system_unique_identifier = s.publicid
WHERE h.source_system_name = 'GWPC'
  AND (s.publicid IS NULL OR h.source_system_unique_identifier <> s.publicid)
