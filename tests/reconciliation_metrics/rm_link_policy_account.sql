-- Phase 9.7: Policy-Account relationship count reconciliation
{{ config(severity='warn') }}
WITH src AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',publicid,accountpublicid)) cnt
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(publicid),'') <> ''
      AND COALESCE(TRIM(accountpublicid),'') <> ''
), tgt AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',policypublicid,accountpublicid)) cnt
    FROM {{ ref('lnk_policy_account') }}
)
SELECT src.cnt source_relationship_count, tgt.cnt link_relationship_count, src.cnt-tgt.cnt difference
FROM src CROSS JOIN tgt
WHERE src.cnt <> tgt.cnt
