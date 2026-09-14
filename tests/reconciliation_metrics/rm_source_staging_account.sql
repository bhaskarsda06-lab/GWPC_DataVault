-- Phase 9.7: Source -> Staging account count reconciliation
WITH src AS (
    SELECT COUNT(*) cnt
    FROM {{ source('gwpc', 'pc_account_curr') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
),
stg AS (
    SELECT COUNT(*) cnt
    FROM {{ ref('stg_account') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
)
SELECT src.cnt source_count, stg.cnt staging_count, src.cnt-stg.cnt difference
FROM src CROSS JOIN stg
WHERE src.cnt <> stg.cnt
