-- Phase 9.5: Account Core satellite parent HK must exist in Hub Account.
SELECT s.account_hk
FROM {{ ref('sat_account_core') }} s
LEFT JOIN {{ ref('hub_account') }} h
  ON s.account_hk = h.account_hk
 AND h.source_system_name = 'GWPC'
WHERE h.account_hk IS NULL
