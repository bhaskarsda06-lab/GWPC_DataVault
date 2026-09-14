SELECT 'satellite_population' AS check_name
WHERE
    (SELECT COUNT(*) FROM {{ ref('sat_account_core') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('sat_account_status') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('sat_contact_details') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('sat_policy_details') }}) = 0
