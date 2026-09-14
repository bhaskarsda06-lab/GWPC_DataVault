-- Phase 6 DQ: Contact Hub mandatory-key validation.
SELECT
    contact_hk,
    source_system_contact_identifier,
    source_system_unique_identifier,
    source_system_name
FROM {{ ref('hub_contact') }}
WHERE contact_hk IS NULL
   OR source_system_contact_identifier IS NULL
   OR source_system_unique_identifier IS NULL
   OR source_system_name IS NULL
