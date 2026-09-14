{{ config(
    materialized='incremental',
    tags=['raw_vault', 'satellite']
) }}

WITH source_data AS (
    SELECT
        sha2(
            concat_ws('|',
                c.PublicID,
                CAST(c.ID AS STRING),
                'GWPC'
            ), 256
        ) AS contact_hk,

        c.FirstName AS first_name,
        c.MiddleName AS middle_name,
        c.LastName AS last_name,
        c.Name AS contact_name,
        c.DateOfBirth AS birth_dt,
        c.TaxID AS tax_id,
        c.EmailAddress1 AS email,
        c.EmailAddress2 AS email_2,
        c.HomePhone AS home_phone,
        c.CellPhone AS cell_phone,

        addr.AddressLine1 AS contact_address_line_1,
        addr.AddressLine2 AS contact_address_line_2,
        addr.AddressLine3 AS contact_address_line_3,
        addr.City AS city,
        addr.PostalCode AS postal_code,
        st.TYPECODE AS state_code,
        co.TYPECODE AS country_code,
        ns.TYPECODE AS name_suffix_code,
        ms.TYPECODE AS marital_status_code,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws('|',
                coalesce(c.FirstName, ''),
                coalesce(c.MiddleName, ''),
                coalesce(c.LastName, ''),
                coalesce(c.Name, ''),
                coalesce(CAST(c.DateOfBirth AS STRING), ''),
                coalesce(c.TaxID, ''),
                coalesce(c.EmailAddress1, ''),
                coalesce(c.EmailAddress2, ''),
                coalesce(c.HomePhone, ''),
                coalesce(c.CellPhone, ''),
                coalesce(addr.AddressLine1, ''),
                coalesce(addr.AddressLine2, ''),
                coalesce(addr.AddressLine3, ''),
                coalesce(addr.City, ''),
                coalesce(addr.PostalCode, ''),
                coalesce(st.TYPECODE, ''),
                coalesce(co.TYPECODE, ''),
                coalesce(ns.TYPECODE, ''),
                coalesce(ms.TYPECODE, '')
            ), 256
        ) AS hashdiff

    FROM {{ source('gwpc', 'pc_contact_curr') }} c

    LEFT JOIN {{ source('gwpc', 'pc_address_curr') }} addr
        ON c.PrimaryAddressID = addr.ID
       AND COALESCE(addr.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_state_curr') }} st
        ON addr.State = st.ID
       AND COALESCE(st.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_country_curr') }} co
        ON addr.Country = co.ID
       AND COALESCE(co.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_namesuffix_curr') }} ns
        ON c.Suffix = ns.ID
       AND COALESCE(ns.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_maritalstatus_curr') }} ms
        ON c.MaritalStatus = ms.ID
       AND COALESCE(ms.Retired, 0) = 0

    WHERE COALESCE(c.Retired, 0) = 0
      AND COALESCE(c.PublicID, '') <> ''
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
    contact_name,
    birth_dt,
    tax_id,
    email,
    email_2,
    home_phone,
    cell_phone,
    contact_address_line_1,
    contact_address_line_2,
    contact_address_line_3,
    city,
    postal_code,
    state_code,
    country_code,
    name_suffix_code,
    marital_status_code,
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
