{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        p.publicid AS policypublicid,
        p.accountpublicid,

        sha2(
            concat_ws(
                '|',
                p.publicid,
                p.accountpublicid,
                'GWPC'
            ),
            256
        ) AS policy_account_hk,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_policy') }} p

    WHERE COALESCE(TRIM(p.publicid), '') <> ''
      AND COALESCE(TRIM(p.accountpublicid), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY policy_account_hk
                ORDER BY policypublicid
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    policy_account_hk,
    policypublicid,
    accountpublicid,
    load_dts

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.policy_account_hk =
          deduplicated.policy_account_hk
)

{% endif %}