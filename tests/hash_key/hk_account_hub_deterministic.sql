-- Phase 9.3: Recalculate Account Hub HK and compare.
SELECT h.account_hk, s.expected_hk
FROM {{ ref('hub_account') }} h
JOIN (
    SELECT DISTINCT
        publicid,
        accountnumber,
        sha2(concat_ws('|', publicid, accountnumber, 'GWPC'), 256) AS expected_hk
    FROM {{ source('gwpc', 'pc_account_curr') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
) s
  ON h.source_system_unique_identifier = s.publicid
WHERE h.source_system_name = 'GWPC'
  AND h.account_hk <> s.expected_hk
