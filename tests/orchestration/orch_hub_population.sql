SELECT 'hub_population' AS check_name
WHERE
    (SELECT COUNT(*) FROM {{ ref('hub_account') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('hub_contact') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('hub_policy') }}) = 0
