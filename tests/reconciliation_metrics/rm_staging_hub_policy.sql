-- Phase 9.7: Staging -> Hub Policy count reconciliation
{{ config(severity='warn') }}
WITH stg AS (
    SELECT COUNT(DISTINCT policynumber) cnt FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(policynumber),'') <> ''
), hub AS (
    SELECT COUNT(DISTINCT policy_number) cnt FROM {{ ref('hub_policy') }}
    WHERE source_system_name='GWPC'
      AND COALESCE(TRIM(policy_number),'') <> ''
)
SELECT stg.cnt staging_count, hub.cnt hub_count, stg.cnt-hub.cnt difference
FROM stg CROSS JOIN hub
WHERE stg.cnt <> hub.cnt
