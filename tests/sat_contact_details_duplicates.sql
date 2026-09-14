SELECT contact_hk, hashdiff, COUNT(*) AS cnt
FROM {{ ref('sat_contact_details') }}
GROUP BY contact_hk, hashdiff
HAVING COUNT(*) > 1
