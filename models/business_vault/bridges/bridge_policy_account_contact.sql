{{ config(
    materialized='table',
    tags=['business_vault', 'bridge']
) }}

WITH policy_account AS (

    SELECT
        policy_account_hk,
        policypublicid,
        accountpublicid
    FROM {{ ref('lnk_policy_account') }}

),

policy_contact AS (

    SELECT
        policy_contact_role_hk,
        policypublicid,
        contactpublicid,
        rolecode
    FROM {{ ref('lnk_policy_contact_role') }}

)

SELECT

    pa.policy_account_hk,

    pcr.policy_contact_role_hk,

    sha2(
        concat_ws(
            '|',
            pa.policypublicid,
            pa.accountpublicid,
            pcr.contactpublicid,
            'GWPC'
        ),
        256
    ) AS policy_account_contact_hk,

    pa.policypublicid,
    pa.accountpublicid,
    pcr.contactpublicid,
    pcr.rolecode,

    current_timestamp() AS load_dts

FROM policy_account pa

INNER JOIN policy_contact pcr
    ON pa.policypublicid = pcr.policypublicid