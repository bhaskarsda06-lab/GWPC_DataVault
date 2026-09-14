-- Phase 6 reconciliation: source distinct business-key population vs Hubs.
WITH source_account AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|', PublicID, AccountNumber, 'GWPC')) AS cnt
    FROM {{ source('gwpc', 'pc_account_curr') }}
    WHERE COALESCE(Retired,0)=0 AND COALESCE(PublicID,'') <> ''
),
target_account AS (
    SELECT COUNT(DISTINCT account_hk) AS cnt FROM {{ ref('hub_account') }}
),
source_contact AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|', PublicID, CAST(ID AS STRING), 'GWPC')) AS cnt
    FROM {{ source('gwpc', 'pc_contact_curr') }}
    WHERE COALESCE(Retired,0)=0 AND COALESCE(PublicID,'') <> ''
),
target_contact AS (
    SELECT COUNT(DISTINCT contact_hk) AS cnt FROM {{ ref('hub_contact') }}
),
source_policy AS (
    SELECT COUNT(DISTINCT CONCAT_WS('|', PublicID, PolicyNumber, CAST(TermNumber AS STRING), 'GWPC')) AS cnt
    FROM {{ source('gwpc', 'pc_policyperiod_curr') }}
    WHERE COALESCE(Retired,0)=0 AND COALESCE(PublicID,'') <> ''
),
target_policy AS (
    SELECT COUNT(DISTINCT policy_hk) AS cnt FROM {{ ref('hub_policy') }}
)
SELECT 'hub_account' AS object_name, source_account.cnt source_count, target_account.cnt target_count,
       source_account.cnt-target_account.cnt difference_count
FROM source_account CROSS JOIN target_account
WHERE source_account.cnt <> target_account.cnt
UNION ALL
SELECT 'hub_contact', source_contact.cnt, target_contact.cnt,
       source_contact.cnt-target_contact.cnt
FROM source_contact CROSS JOIN target_contact
WHERE source_contact.cnt <> target_contact.cnt
UNION ALL
SELECT 'hub_policy', source_policy.cnt, target_policy.cnt,
       source_policy.cnt-target_policy.cnt
FROM source_policy CROSS JOIN target_policy
WHERE source_policy.cnt <> target_policy.cnt
