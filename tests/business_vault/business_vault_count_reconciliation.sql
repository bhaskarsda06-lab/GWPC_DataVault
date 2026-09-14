-- Phase 8.5
WITH c AS (
 SELECT 'lnk_account_contact' object_name,
 (SELECT COUNT(DISTINCT CONCAT(TRIM(CAST(accountpublicid AS STRING)),'|',TRIM(CAST(contactpublicid AS STRING))))
  FROM {{ ref('stg_accountcontact') }} WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>'') expected_count,
 (SELECT COUNT(*) FROM {{ ref('lnk_account_contact') }}) actual_count
 UNION ALL
 SELECT 'lnk_account_contact_role',
 (SELECT COUNT(DISTINCT CONCAT(TRIM(CAST(accountpublicid AS STRING)),'|',TRIM(CAST(contactpublicid AS STRING)),'|',TRIM(CAST(rolecode AS STRING))))
  FROM {{ ref('stg_accountcontactrole') }} WHERE COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(rolecode AS STRING)),'')<>''),
 (SELECT COUNT(*) FROM {{ ref('lnk_account_contact_role') }})
 UNION ALL
 SELECT 'lnk_policy_account',
 (SELECT COUNT(DISTINCT CONCAT(TRIM(CAST(publicid AS STRING)),'|',TRIM(CAST(accountpublicid AS STRING))))
  FROM {{ ref('stg_policy') }} WHERE COALESCE(TRIM(CAST(publicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(accountpublicid AS STRING)),'')<>''),
 (SELECT COUNT(*) FROM {{ ref('lnk_policy_account') }})
 UNION ALL
 SELECT 'lnk_policy_contact_role',
 (SELECT COUNT(DISTINCT CONCAT(TRIM(CAST(policypublicid AS STRING)),'|',TRIM(CAST(contactpublicid AS STRING)),'|',TRIM(CAST(rolecode AS STRING))))
  FROM {{ ref('stg_policycontactrole') }} WHERE COALESCE(TRIM(CAST(policypublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(contactpublicid AS STRING)),'')<>'' AND COALESCE(TRIM(CAST(rolecode AS STRING)),'')<>''),
 (SELECT COUNT(*) FROM {{ ref('lnk_policy_contact_role') }})
)
SELECT object_name,expected_count,actual_count,expected_count-actual_count difference
FROM c WHERE expected_count<>actual_count
