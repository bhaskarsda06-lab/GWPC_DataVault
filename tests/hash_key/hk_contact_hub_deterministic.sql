-- Phase 9.3: Recalculate Contact Hub HK and compare.
SELECT h.contact_hk, s.expected_hk
FROM {{ ref('hub_contact') }} h
JOIN (
    SELECT DISTINCT
        publicid,
        id,
        sha2(concat_ws('|', publicid, CAST(id AS STRING), 'GWPC'), 256) AS expected_hk
    FROM {{ source('gwpc', 'pc_contact_curr') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
) s
  ON h.source_system_unique_identifier = s.publicid
WHERE h.source_system_name = 'GWPC'
  AND h.contact_hk <> s.expected_hk
