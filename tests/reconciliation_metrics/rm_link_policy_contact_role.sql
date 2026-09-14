-- Phase 9.7: Policy-Contact-Role relationship count reconciliation
WITH src AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',policypublicid,contactpublicid,rolecode)) cnt
    FROM {{ ref('stg_policycontactrole') }}
    WHERE COALESCE(TRIM(policypublicid),'') <> ''
      AND COALESCE(TRIM(contactpublicid),'') <> ''
      AND COALESCE(TRIM(rolecode),'') <> ''
), tgt AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|',policypublicid,contactpublicid,rolecode)) cnt
    FROM {{ ref('lnk_policy_contact_role') }}
)
SELECT src.cnt source_relationship_count, tgt.cnt link_relationship_count, src.cnt-tgt.cnt difference
FROM src CROSS JOIN tgt
WHERE src.cnt <> tgt.cnt
