-- Phase 9.7: Account-Contact relationship count reconciliation
WITH src AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',accountpublicid,contactpublicid)) cnt
    FROM {{ ref('stg_accountcontact') }}
    WHERE COALESCE(TRIM(accountpublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
), tgt AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',accountpublicid,contactpublicid)) cnt
    FROM {{ ref('lnk_account_contact') }}
)
SELECT src.cnt source_relationship_count, tgt.cnt link_relationship_count, src.cnt-tgt.cnt difference
FROM src CROSS JOIN tgt
WHERE src.cnt <> tgt.cnt
