-- Phase 8.4
-- Satellite -> Hub referential integrity.
-- sat_account_core must have a valid Account Hub parent.

SELECT
    s.account_hk
FROM {{ ref('sat_account_core') }} s
LEFT JOIN {{ ref('hub_account') }} h
    ON h.account_hk = s.account_hk
   AND h.source_system_name = 'GWPC'
WHERE h.account_hk IS NULL