{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
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

        ha.account_hk,
        hc.contact_hk,

        acr.accountpublicid,
        acr.contactpublicid,
        acr.rolecode,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_accountcontactrole') }} acr

    INNER JOIN {{ ref('hub_account') }} ha
        ON ha.source_system_unique_identifier =
           acr.accountpublicid
       AND ha.source_system_name = 'GWPC'

    INNER JOIN {{ ref('hub_contact') }} hc
        ON hc.source_system_unique_identifier =
           acr.contactpublicid
       AND hc.source_system_name = 'GWPC'

    WHERE COALESCE(TRIM(acr.accountpublicid), '') <> ''
      AND COALESCE(TRIM(acr.contactpublicid), '') <> ''
      AND COALESCE(TRIM(acr.rolecode), '') <> ''
)

SELECT
    account_contact_role_hk,
    account_hk,
    contact_hk,
    accountpublicid,
    contactpublicid,
    rolecode,
    load_dts

FROM source_data

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.account_contact_role_hk =
          source_data.account_contact_role_hk
)

{% endif %}