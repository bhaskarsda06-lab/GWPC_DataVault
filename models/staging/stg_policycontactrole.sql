{{ config(
    materialized='view',
    tags=['staging', 'policy', 'contact']
) }}

SELECT
    publicid,
    policypublicid,
    contactpublicid,
    rolecode,
    createddate,
    updateddate,
    retired
FROM {{ source('gwpc', 'pc_policycontactrole_curr') }}