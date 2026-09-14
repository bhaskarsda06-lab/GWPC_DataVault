{{ config(
    materialized='incremental',
    tags=['raw_vault', 'satellite']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                c.PublicID,
                CAST(c.ID AS STRING),
                'GWPC'
            ),
            256
        ) AS contact_hk,

        c.FirstName AS first_name,
        c.MiddleName AS middle_name,
        c.LastName AS last_name,
        c.Email AS email,
        c.Phone AS phone,

        c.CreatedDate AS contact_created_date,
        c.UpdatedDate AS contact_updated_date,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws(
                '|',
                coalesce(c.FirstName, ''),
                coalesce(c.MiddleName, ''),
                coalesce(c.LastName, ''),
                coalesce(c.Email, ''),
                coalesce(c.Phone, ''),
                coalesce(CAST(c.CreatedDate AS STRING), ''),
                coalesce(CAST(c.UpdatedDate AS STRING), '')
            ),
            256
        ) AS hashdiff

    FROM {{ source('gwpc', 'pc_contact_curr') }} c

    WHERE COALESCE(c.Retired, 0) = 0
      AND COALESCE(TRIM(c.PublicID), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY contact_hk, hashdiff
                ORDER BY load_dts DESC
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    contact_hk,
    first_name,
    middle_name,
    last_name,
    email,
    phone,
    contact_created_date,
    contact_updated_date,
    load_dts,
    hashdiff

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.contact_hk = deduplicated.contact_hk
      AND t.hashdiff = deduplicated.hashdiff
)

{% endif %}