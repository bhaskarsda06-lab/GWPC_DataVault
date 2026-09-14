{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        acr.publicid,
        acr.accountpublicid,
        acr.contactpublicid,
        acr.rolecode,
        acr.createddate,
        acr.updateddate,

        sha2(
            concat_ws(
                '|',
                acr.accountpublicid,
                acr.contactpublicid,
                acr.rolecode,
                'GWPC'
            ),
            256
        ) AS account_contact_role_hk,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_accountcontactrole') }} acr

    WHERE COALESCE(TRIM(acr.accountpublicid), '') <> ''
      AND COALESCE(TRIM(acr.contactpublicid), '') <> ''
      AND COALESCE(TRIM(acr.rolecode), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY account_contact_role_hk
                ORDER BY updateddate DESC, createddate DESC
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    account_contact_role_hk,
    accountpublicid,
    contactpublicid,
    rolecode,
    load_dts

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.account_contact_role_hk =
          deduplicated.account_contact_role_hk
)

{% endif %}