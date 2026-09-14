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

        a.AccountName AS account_name,
        a.AccountType AS account_type,
        a.Status AS account_status,

        a.CreatedDate AS account_created_date,
        a.UpdatedDate AS account_updated_date,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws(
                '|',
                coalesce(a.AccountName, ''),
                coalesce(a.AccountType, ''),
                coalesce(a.Status, ''),
                coalesce(cast(a.CreatedDate AS STRING), ''),
                coalesce(cast(a.UpdatedDate AS STRING), '')
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
    account_name,
    account_type,
    account_status,
    account_created_date,
    account_updated_date,
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