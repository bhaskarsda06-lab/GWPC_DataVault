SELECT
    'environment' AS check_name
WHERE
    '{{ target.database }}' <> 'autdbt_vault_prod'
    OR '{{ target.schema }}' <> 'autdbtt'