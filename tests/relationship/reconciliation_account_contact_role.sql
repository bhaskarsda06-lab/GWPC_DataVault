-- Phase 8.3
-- Account -> Contact Role relationship reconciliation.

WITH source_relationship AS (

    SELECT DISTINCT
        TRIM(accountpublicid) AS accountpublicid,
        TRIM(contactpublicid) AS contactpublicid,
        TRIM(rolecode) AS rolecode
    FROM {{ ref('stg_accountcontactrole') }}
    WHERE COALESCE(TRIM(accountpublicid), '') <> ''
      AND COALESCE(TRIM(contactpublicid), '') <> ''
      AND COALESCE(TRIM(rolecode), '') <> ''

),

link_relationship AS (

    SELECT DISTINCT
        TRIM(accountpublicid) AS accountpublicid,
        TRIM(contactpublicid) AS contactpublicid,
        TRIM(rolecode) AS rolecode
    FROM {{ ref('lnk_account_contact_role') }}

)

SELECT
    s.accountpublicid,
    s.contactpublicid,
    s.rolecode
FROM source_relationship s
LEFT JOIN link_relationship l
    ON l.accountpublicid = s.accountpublicid
   AND l.contactpublicid = s.contactpublicid
   AND l.rolecode = s.rolecode
WHERE l.accountpublicid IS NULL