-- Phase 8.2
-- Reconciliation: Staging business-key population vs Hub population.
{{ config(severity='warn') }}

WITH source_account AS (

    SELECT COUNT(DISTINCT TRIM(CAST(publicid AS STRING))) AS cnt
    FROM {{ ref('stg_account') }}
    WHERE COALESCE(TRIM(CAST(publicid AS STRING)), '') <> ''

),

target_account AS (

    SELECT COUNT(DISTINCT source_system_unique_identifier) AS cnt
    FROM {{ ref('hub_account') }}
    WHERE source_system_name = 'GWPC'
      AND COALESCE(TRIM(source_system_unique_identifier), '') <> ''

),

source_contact AS (

    SELECT COUNT(DISTINCT TRIM(CAST(publicid AS STRING))) AS cnt
    FROM {{ ref('stg_contact') }}
    WHERE COALESCE(TRIM(CAST(publicid AS STRING)), '') <> ''

),

target_contact AS (

    SELECT COUNT(DISTINCT source_system_unique_identifier) AS cnt
    FROM {{ ref('hub_contact') }}
    WHERE source_system_name = 'GWPC'
      AND COALESCE(TRIM(source_system_unique_identifier), '') <> ''

),

source_policy AS (

    SELECT COUNT(DISTINCT TRIM(CAST(policynumber AS STRING))) AS cnt
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(CAST(policynumber AS STRING)), '') <> ''

),

target_policy AS (

    SELECT COUNT(DISTINCT policy_number) AS cnt
    FROM {{ ref('hub_policy') }}
    WHERE source_system_name = 'GWPC'
      AND COALESCE(TRIM(policy_number), '') <> ''

)

SELECT
    'hub_account' AS object_name,
    source_account.cnt AS source_count,
    target_account.cnt AS target_count,
    source_account.cnt - target_account.cnt AS difference_count
FROM source_account
CROSS JOIN target_account
WHERE source_account.cnt <> target_account.cnt

UNION ALL

SELECT
    'hub_contact' AS object_name,
    source_contact.cnt AS source_count,
    target_contact.cnt AS target_count,
    source_contact.cnt - target_contact.cnt AS difference_count
FROM source_contact
CROSS JOIN target_contact
WHERE source_contact.cnt <> target_contact.cnt

UNION ALL

SELECT
    'hub_policy' AS object_name,
    source_policy.cnt AS source_count,
    target_policy.cnt AS target_count,
    source_policy.cnt - target_policy.cnt AS difference_count
FROM source_policy
CROSS JOIN target_policy
WHERE source_policy.cnt <> target_policy.cnt