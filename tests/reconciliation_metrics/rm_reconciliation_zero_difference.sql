-- Phase 9.7: Consolidated zero-difference sanity check for core counts.
{{ config(severity='warn') }}
WITH metrics AS (
    SELECT 'account_source_staging' metric, 
           (SELECT COUNT(*) FROM {{ source('gwpc','pc_account_curr') }} WHERE COALESCE(TRIM(publicid),'')<>'') -
           (SELECT COUNT(*) FROM {{ ref('stg_account') }} WHERE COALESCE(TRIM(publicid),'')<>'') diff
    UNION ALL
    SELECT 'contact_source_staging',
           (SELECT COUNT(*) FROM {{ source('gwpc','pc_contact_curr') }} WHERE COALESCE(TRIM(publicid),'')<>'') -
           (SELECT COUNT(*) FROM {{ ref('stg_contact') }} WHERE COALESCE(TRIM(publicid),'')<>'')
    UNION ALL
    SELECT 'policy_source_staging',
           (SELECT COUNT(*) FROM {{ source('gwpc','pc_policy_curr') }} WHERE COALESCE(TRIM(publicid),'')<>'') -
           (SELECT COUNT(*) FROM {{ ref('stg_policy') }} WHERE COALESCE(TRIM(publicid),'')<>'')
)
SELECT metric, diff
FROM metrics
WHERE diff <> 0
