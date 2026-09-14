-- Phase 8.3
-- Account -> Contact relationship reconciliation.

WITH source_relationship AS (

    SELECT DISTINCT
        TRIM(accountpublicid) AS accountpublicid,
        TRIM(contactpublicid) AS contactpublicid
    FROM {{ ref('stg_accountcontact') }}
    WHERE COALESCE(TRIM(accountpublicid), '') <> ''
      AND COALESCE(TRIM(contactpublicid), '') <> ''

),

link_relationship AS (

    SELECT DISTINCT
        TRIM(accountpublicid) AS accountpublicid,
        TRIM(contactpublicid) AS contactpublicid
    FROM {{ ref('lnk_account_contact') }}

)

SELECT
    s.accountpublicid,
    s.contactpublicid
FROM source_relationship s
LEFT JOIN link_relationship l
    ON l.accountpublicid = s.accountpublicid
   AND l.contactpublicid = s.contactpublicid
WHERE l.accountpublicid IS NULL