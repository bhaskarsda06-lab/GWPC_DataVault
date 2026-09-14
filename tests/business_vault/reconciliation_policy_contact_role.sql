-- Phase 8.5
WITH s AS (
 SELECT DISTINCT TRIM(CAST(policypublicid AS STRING)) policypublicid,
 TRIM(CAST(contactpublicid AS STRING)) contactpublicid, TRIM(CAST(rolecode AS STRING)) rolecode
 FROM {{ ref('stg_policycontactrole') }}
 WHERE COALESCE(TRIM(CAST(policypublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(rolecode AS STRING)),'')<>''
), t AS (
 SELECT DISTINCT TRIM(CAST(policypublicid AS STRING)) policypublicid,
 TRIM(CAST(contactpublicid AS STRING)) contactpublicid, TRIM(CAST(rolecode AS STRING)) rolecode
 FROM {{ ref('lnk_policy_contact_role') }}
)
SELECT s.* FROM s LEFT JOIN t ON s.policypublicid=t.policypublicid AND s.contactpublicid=t.contactpublicid AND s.rolecode=t.rolecode
WHERE t.policypublicid IS NULL
