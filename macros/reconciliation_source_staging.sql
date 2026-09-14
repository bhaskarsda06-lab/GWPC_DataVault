{% test reconciliation_source_staging(model, source_table, source_key, staging_key) %}

WITH source_count AS (

    SELECT COUNT(*) AS cnt
    FROM {{ source_table }}
    WHERE COALESCE(TRIM(CAST({{ source_key }} AS STRING)), '') <> ''

),

staging_count AS (

    SELECT COUNT(*) AS cnt
    FROM {{ model }}
    WHERE COALESCE(TRIM(CAST({{ staging_key }} AS STRING)), '') <> ''

)

SELECT
    source_count.cnt AS source_count,
    staging_count.cnt AS staging_count,
    source_count.cnt - staging_count.cnt AS difference

FROM source_count
CROSS JOIN staging_count

WHERE source_count.cnt <> staging_count.cnt

{% endtest %}