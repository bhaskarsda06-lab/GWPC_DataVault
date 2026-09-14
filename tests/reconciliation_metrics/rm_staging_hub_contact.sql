-- Phase 9.7: Staging -> Hub Contact count reconciliation
WITH stg AS (
    SELECT COUNT(DISTINCT publicid) cnt FROM {{ ref('stg_contact') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
), hub AS (
    SELECT COUNT(DISTINCT source_system_unique_identifier) cnt FROM {{ ref('hub_contact') }}
    WHERE source_system_name='GWPC'
      AND COALESCE(TRIM(source_system_unique_identifier),'') <> ''
)
SELECT stg.cnt staging_count, hub.cnt hub_count, stg.cnt-hub.cnt difference
FROM stg CROSS JOIN hub
WHERE stg.cnt <> hub.cnt
