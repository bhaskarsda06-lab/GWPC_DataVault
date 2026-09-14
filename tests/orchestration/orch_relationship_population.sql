SELECT 'relationship_population' AS check_name
WHERE
    (SELECT COUNT(*) FROM {{ ref('lnk_account_contact') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('lnk_account_contact_role') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('lnk_policy_account') }}) = 0
 OR (SELECT COUNT(*) FROM {{ ref('lnk_policy_contact_role') }}) = 0
