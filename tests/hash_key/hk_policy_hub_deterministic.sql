-- Phase 9.3: Recalculate Policy Hub HK and compare.
SELECT h.policy_hk, s.expected_hk
FROM {{ ref('hub_policy') }} h
JOIN (
    SELECT DISTINCT
        policynumber,
        termnumber,
        publicid,
        sha2(concat_ws('|', publicid, policynumber, termnumber, 'GWPC'), 256) AS expected_hk
    FROM {{ source('gwpc', 'pc_policyperiod_curr') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
      AND COALESCE(TRIM(policynumber),'') <> ''
) s
  ON h.policy_number = s.policynumber
 AND CAST(h.term_number AS STRING) = CAST(s.termnumber AS STRING)
WHERE h.source_system_name = 'GWPC'
  AND h.policy_hk <> s.expected_hk
