-- Phase 9.8: Policy Hub must map policy number to staging Policy.
{{ config(severity='warn') }}
SELECT h.policy_hk, h.policy_number, s.policynumber
FROM {{ ref('hub_policy') }} h
LEFT JOIN {{ ref('stg_policy') }} s
  ON h.policy_number = s.policynumber
WHERE h.source_system_name = 'GWPC'
  AND (s.policynumber IS NULL OR h.policy_number <> s.policynumber)
