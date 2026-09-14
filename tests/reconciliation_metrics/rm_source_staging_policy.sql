-- Phase 9.7: Source -> Staging policy count reconciliation
WITH src AS (
    SELECT COUNT(*) cnt FROM {{ source('gwpc', 'pc_policy_curr') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
), stg AS (
    SELECT COUNT(*) cnt FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
)
SELECT src.cnt source_count, stg.cnt staging_count, src.cnt-stg.cnt difference
FROM src CROSS JOIN stg
WHERE src.cnt <> stg.cnt
