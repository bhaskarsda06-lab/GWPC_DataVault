{% macro insert_reconciliation(
    run_id,
    reconciliation_id,
    source_object,
    target_object,
    source_count,
    target_count
) %}

INSERT INTO {{ target.database }}.autdbts.dv_reconciliation
SELECT
    '{{ run_id }}',
    '{{ reconciliation_id }}',
    '{{ source_object }}',
    '{{ target_object }}',
    {{ source_count }},
    {{ target_count }},
    {{ source_count }} - {{ target_count }},
    CASE WHEN {{ source_count }} = {{ target_count }} THEN 'PASS' ELSE 'FAIL' END,
    current_timestamp(),
    NULL

{% endmacro %}
