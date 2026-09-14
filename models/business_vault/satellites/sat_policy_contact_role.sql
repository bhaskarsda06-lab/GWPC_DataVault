{{ config(
    materialized='incremental',
    tags=['business_vault', 'satellite']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                policypublicid,
                contactpublicid,
                rolecode,
                'GWPC'
            ),
            256
        ) AS policy_contact_role_hk,

        rolecode AS policy_contact_role_code,

        createddate AS relationship_created_date,
        updateddate AS relationship_updated_date,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws(
                '|',
                coalesce(rolecode, ''),
                coalesce(
                    cast(createddate AS STRING),
                    ''
                ),
                coalesce(
                    cast(updateddate AS STRING),
                    ''
                )
            ),
            256
        ) AS hashdiff

    FROM {{ ref('stg_policycontactrole') }}

    WHERE COALESCE(TRIM(policypublicid), '') <> ''
      AND COALESCE(TRIM(contactpublicid), '') <> ''
      AND COALESCE(TRIM(rolecode), '') <> ''
)

SELECT
    policy_contact_role_hk,
    policy_contact_role_code,
    relationship_created_date,
    relationship_updated_date,
    load_dts,
    hashdiff

FROM source_data

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.policy_contact_role_hk =
          source_data.policy_contact_role_hk
      AND t.hashdiff = source_data.hashdiff
)

{% endif %}