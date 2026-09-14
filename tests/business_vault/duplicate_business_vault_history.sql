-- Phase 8.5
SELECT object_name,parent_hk,hashdiff,record_count FROM (
 SELECT 'sat_account_contact_role' object_name,account_contact_role_hk parent_hk,hashdiff,COUNT(*) record_count
 FROM {{ ref('sat_account_contact_role') }} GROUP BY account_contact_role_hk,hashdiff HAVING COUNT(*)>1
 UNION ALL
 SELECT 'sat_policy_contact_role',policy_contact_role_hk,hashdiff,COUNT(*)
 FROM {{ ref('sat_policy_contact_role') }} GROUP BY policy_contact_role_hk,hashdiff HAVING COUNT(*)>1
)
