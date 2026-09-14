-- Phase 8.3
-- Policy -> Account relationship reconciliation.

WITH source_relationship AS (

    SELECT DISTINCT
        TRIM(publicid) AS policypublicid,
        TRIM(policynumber) AS policynumber,
        TRIM(accountpublicid) AS accountpublicid
    FROM {{ ref('stg_policy') }}
    WHERE COALESCE(TRIM(publicid), '') <> ''
      AND COALESCE(TRIM(policynumber), '') <> ''
      AND COALESCE(TRIM(accountpublicid), '') <> ''

),

link_relationship AS (

    SELECT DISTINCT
        TRIM(policypublicid) AS policypublicid,
        TRIM(accountpublicid) AS accountpublicid
    FROM {{ ref('lnk_policy_account') }}

)

SELECT
    s.policypublicid,
    s.policynumber,
    s.accountpublicid
FROM source_relationship s
LEFT JOIN link_relationship l
    ON l.policypublicid = s.policypublicid
   AND l.accountpublicid = s.accountpublicid
WHERE l.policypublicid IS NULL