-- Phase 8.5: source relationship completeness
WITH s AS (
 SELECT DISTINCT TRIM(CAST(accountpublicid AS STRING)) accountpublicid,
                 TRIM(CAST(contactpublicid AS STRING)) contactpublicid
 FROM {{ ref('stg_accountcontact') }}
 WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>''
), t AS (
 SELECT DISTINCT TRIM(CAST(accountpublicid AS STRING)) accountpublicid,
                 TRIM(CAST(contactpublicid AS STRING)) contactpublicid
 FROM {{ ref('lnk_account_contact') }}
)
SELECT s.* FROM s LEFT JOIN t ON s.accountpublicid=t.accountpublicid AND s.contactpublicid=t.contactpublicid
WHERE t.accountpublicid IS NULL
