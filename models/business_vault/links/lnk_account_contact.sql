{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        ac.publicid,
        ac.accountpublicid,
        ac.contactpublicid,
        ac.createddate,
        ac.updateddate,

        sha2(
            concat_ws(
                '|',
                ac.accountpublicid,
                ac.contactpublicid,
                'GWPC'
            ),
            256
        ) AS account_contact_hk,

        sha2(
            concat_ws(
                '|',
                ac.accountpublicid,
                ac.contactpublicid,
                'GWPC'
            ),
            256
        ) AS link_hashkey,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_accountcontact') }} ac

    WHERE COALESCE(TRIM(ac.accountpublicid), '') <> ''
      AND COALESCE(TRIM(ac.contactpublicid), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY account_contact_hk
                ORDER BY updateddate DESC, createddate DESC
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    account_contact_hk,
    account_contact_hk AS link_hashkey,
    accountpublicid,
    contactpublicid,
    load_dts

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.account_contact_hk = deduplicated.account_contact_hk
)

{% endif %}