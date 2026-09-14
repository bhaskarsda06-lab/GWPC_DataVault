{{ config(
    materialized='incremental',
    tags=['raw_vault', 'satellite']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                a.PublicID,
                a.AccountNumber,
                'GWPC'
            ),
            256
        ) AS account_hk,

        a.Status AS account_status_code,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws(
                '|',
                coalesce(a.Status, '')
            ),
            256
        ) AS hashdiff

    FROM {{ source('gwpc', 'pc_account_curr') }} a

    WHERE COALESCE(a.Retired, 0) = 0
      AND COALESCE(TRIM(a.PublicID), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY account_hk, hashdiff
                ORDER BY load_dts DESC
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    account_hk,
    account_status_code,
    load_dts,
    hashdiff

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.account_hk = deduplicated.account_hk
      AND t.hashdiff = deduplicated.hashdiff
)

{% endif %}