-- Phase 8.5
WITH s AS (
 SELECT DISTINCT TRIM(CAST(publicid AS STRING)) policypublicid,
 TRIM(CAST(policynumber AS STRING)) policynumber, TRIM(CAST(accountpublicid AS STRING)) accountpublicid
 FROM {{ ref('stg_policy') }}
 WHERE COALESCE(TRIM(CAST(publicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(policynumber AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>''
), t AS (
 SELECT DISTINCT TRIM(CAST(policypublicid AS STRING)) policypublicid,
 TRIM(CAST(accountpublicid AS STRING)) accountpublicid FROM {{ ref('lnk_policy_account') }}
)
SELECT s.* FROM s LEFT JOIN t ON s.policypublicid=t.policypublicid AND s.accountpublicid=t.accountpublicid
WHERE t.policypublicid IS NULL
