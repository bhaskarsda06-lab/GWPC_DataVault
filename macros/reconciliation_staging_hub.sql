{% test reconciliation_staging_hub(
    model,
    staging_model,
    staging_key,
    hub_key,
    hub_business_key,
    source_system
) %}

WITH staging_data AS (

    SELECT DISTINCT
        TRIM(CAST({{ staging_key }} AS STRING)) AS business_key
    FROM {{ ref(staging_model) }}
    WHERE COALESCE(TRIM(CAST({{ staging_key }} AS STRING)), '') <> ''

),

hub_data AS (

    SELECT DISTINCT
        TRIM(CAST({{ hub_business_key }} AS STRING)) AS business_key,
        {{ hub_key }} AS hub_hash_key
    FROM {{ model }}
    WHERE source_system_name = '{{ source_system }}'
      AND COALESCE(TRIM(CAST({{ hub_business_key }} AS STRING)), '') <> ''

),

missing_records AS (

    SELECT
        s.business_key,
        h.hub_hash_key
    FROM staging_data s
    LEFT JOIN hub_data h
        ON s.business_key = h.business_key
    WHERE h.hub_hash_key IS NULL

)

SELECT *
FROM missing_records

{% endtest %}