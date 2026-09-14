{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                ac.accountpublicid,
                ac.contactpublicid,
                'GWPC'
            ),
            256
        ) AS account_contact_hk,

        ha.account_hk,
        hc.contact_hk,

        ac.accountpublicid,
        ac.contactpublicid,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_accountcontact') }} ac

    INNER JOIN {{ ref('hub_account') }} ha
        ON ha.source_system_unique_identifier =
           ac.accountpublicid
       AND ha.source_system_name = 'GWPC'

    INNER JOIN {{ ref('hub_contact') }} hc
        ON hc.source_system_unique_identifier =
           ac.contactpublicid
       AND hc.source_system_name = 'GWPC'

    WHERE COALESCE(TRIM(ac.accountpublicid), '') <> ''
      AND COALESCE(TRIM(ac.contactpublicid), '') <> ''
)

SELECT
    account_contact_hk,
    account_hk,
    contact_hk,
    accountpublicid,
    contactpublicid,
    load_dts

FROM source_data

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.account_contact_hk =
          source_data.account_contact_hk
)

{% endif %}