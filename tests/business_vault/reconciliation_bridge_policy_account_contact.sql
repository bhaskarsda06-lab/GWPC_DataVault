-- Phase 8.5
WITH expected AS (
 SELECT DISTINCT pa.policy_account_hk,pcr.policy_contact_role_hk,pa.policypublicid,pa.accountpublicid,pcr.contactpublicid
 FROM {{ ref('lnk_policy_account') }} pa
 JOIN {{ ref('lnk_policy_contact_role') }} pcr ON pa.policypublicid=pcr.policypublicid
), actual AS (
 SELECT DISTINCT policy_account_hk,policy_contact_role_hk,policypublicid,accountpublicid,contactpublicid
 FROM {{ ref('bridge_policy_account_contact') }}
)
SELECT e.* FROM expected e
LEFT JOIN actual a ON e.policy_account_hk=a.policy_account_hk AND e.policy_contact_role_hk=a.policy_contact_role_hk
 AND e.policypublicid=a.policypublicid AND e.accountpublicid=a.accountpublicid AND e.contactpublicid=a.contactpublicid
WHERE a.policy_account_hk IS NULL
