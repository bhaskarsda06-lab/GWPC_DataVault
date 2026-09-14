-- Phase 6 DQ: Policy Hub mandatory-key validation.
SELECT
    policy_hk,
    source_system_unique_identifier,
    policy_number,
    term_number,
    source_system_name
FROM {{ ref('hub_policy') }}
WHERE policy_hk IS NULL
   OR source_system_unique_identifier IS NULL
   OR policy_number IS NULL
   OR term_number IS NULL
   OR source_system_name IS NULL
