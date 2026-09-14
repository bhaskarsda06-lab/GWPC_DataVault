{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                p.publicid,
                p.accountpublicid,
                'GWPC'
            ),
            256
        ) AS policy_account_hk,

        hp.policy_hk,
        ha.account_hk,

        p.publicid AS policypublicid,
        p.accountpublicid,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_policy') }} p

    INNER JOIN {{ ref('hub_policy') }} hp
        ON hp.policy_number = p.policynumber
       AND hp.source_system_name = 'GWPC'

    INNER JOIN {{ ref('hub_account') }} ha
        ON ha.source_system_unique_identifier =
           p.accountpublicid
       AND ha.source_system_name = 'GWPC'

    WHERE COALESCE(TRIM(p.publicid), '') <> ''
      AND COALESCE(TRIM(p.policynumber), '') <> ''
      AND COALESCE(TRIM(p.accountpublicid), '') <> ''
)

SELECT
    policy_account_hk,
    policy_hk,
    account_hk,
    policypublicid,
    accountpublicid,
    load_dts

FROM source_data

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.policy_account_hk =
          source_data.policy_account_hk
)

{% endif %}