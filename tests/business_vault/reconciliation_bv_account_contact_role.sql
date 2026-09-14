-- Phase 8.5
WITH s AS (
 SELECT DISTINCT TRIM(CAST(accountpublicid AS STRING)) accountpublicid,
 TRIM(CAST(contactpublicid AS STRING)) contactpublicid, TRIM(CAST(rolecode AS STRING)) rolecode
 FROM {{ ref('stg_accountcontactrole') }}
 WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(rolecode AS STRING)),'')<>''
), t AS (
 SELECT DISTINCT TRIM(CAST(accountpublicid AS STRING)) accountpublicid,
 TRIM(CAST(contactpublicid AS STRING)) contactpublicid, TRIM(CAST(rolecode AS STRING)) rolecode
 FROM {{ ref('lnk_account_contact_role') }}
)
SELECT s.* FROM s LEFT JOIN t ON s.accountpublicid=t.accountpublicid AND s.contactpublicid=t.contactpublicid AND s.rolecode=t.rolecode
WHERE t.accountpublicid IS NULL
