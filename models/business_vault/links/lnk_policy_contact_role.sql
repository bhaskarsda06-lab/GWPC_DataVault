{{ config(
    materialized='incremental',
    tags=['business_vault', 'link']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                pcr.policypublicid,
                pcr.contactpublicid,
                pcr.rolecode,
                'GWPC'
            ),
            256
        ) AS policy_contact_role_hk,

        hp.policy_hk,
        hc.contact_hk,

        pcr.policypublicid,
        pcr.contactpublicid,
        pcr.rolecode,

        current_timestamp() AS load_dts

    FROM {{ ref('stg_policycontactrole') }} pcr

    INNER JOIN {{ ref('stg_policy') }} p
        ON p.publicid = pcr.policypublicid

    INNER JOIN {{ ref('hub_policy') }} hp
        ON hp.policy_number = p.policynumber
       AND hp.source_system_name = 'GWPC'

    INNER JOIN {{ ref('hub_contact') }} hc
        ON hc.source_system_unique_identifier =
           pcr.contactpublicid
       AND hc.source_system_name = 'GWPC'

    WHERE COALESCE(TRIM(pcr.policypublicid), '') <> ''
      AND COALESCE(TRIM(pcr.contactpublicid), '') <> ''
      AND COALESCE(TRIM(pcr.rolecode), '') <> ''
)

SELECT
    policy_contact_role_hk,
    policy_hk,
    contact_hk,
    policypublicid,
    contactpublicid,
    rolecode,
    load_dts

FROM source_data

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.policy_contact_role_hk =
          source_data.policy_contact_role_hk
)

{% endif %}