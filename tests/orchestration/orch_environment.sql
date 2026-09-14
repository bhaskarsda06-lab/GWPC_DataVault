SELECT 'environment' AS check_name
WHERE '{{ target.name }}' <> 'prod'
