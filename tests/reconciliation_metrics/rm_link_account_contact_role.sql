-- Phase 9.7: Account-Contact-Role relationship count reconciliation
{{ config(severity='warn') }}
WITH src AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',accountpublicid,contactpublicid,rolecode)) cnt
    FROM {{ ref('stg_accountcontactrole') }}
    WHERE COALESCE(TRIM(accountpublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
      AND COALESCE(TRIM(rolecode),'') <> ''
), tgt AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',accountpublicid,contactpublicid,rolecode)) cnt
    FROM {{ ref('lnk_account_contact_role') }}
)
SELECT src.cnt source_relationship_count, tgt.cnt link_relationship_count, src.cnt-tgt.cnt difference
FROM src CROSS JOIN tgt
WHERE src.cnt <> tgt.cnt
