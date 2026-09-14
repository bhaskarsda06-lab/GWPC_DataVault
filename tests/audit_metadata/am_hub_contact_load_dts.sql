-- Phase 9.6: Hub Contact load timestamp must be populated and not future-dated.
SELECT contact_hk, load_dts
FROM {{ ref('hub_contact') }}
WHERE load_dts IS NULL
   OR load_dts > current_timestamp()
