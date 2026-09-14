{{ config(
    materialized='incremental',
    tags=['raw_vault', 'satellite']
) }}

WITH source_data AS (

    SELECT
        sha2(
            concat_ws(
                '|',
                pp.PublicID,
                pp.PolicyNumber,
                CAST(pp.TermNumber AS STRING),
                'GWPC'
            ),
            256
        ) AS policy_hk,

        pp.PolicyNumber AS policy_number,

        pp.TermNumber AS term_number,

        pp.PeriodNumber AS period_number,

        pp.EffectiveFrom AS policy_effective_ts,

        pp.EffectiveTo AS policy_expiration_ts,

        pp.StatusCode AS transaction_status_code,

        pps.PaymentPlan AS payment_plan_code,

        pps.PremiumAmount AS payment_plan_premium_amount,

        pps.CurrencyCode AS payment_plan_currency_code,

        edf.EffectiveDate AS effective_date,

        edf.ExpirationDate AS expiration_date,

        CAST(NULL AS STRING) AS insured_legal_name,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws(
                '|',
                coalesce(pp.PolicyNumber, ''),
                coalesce(CAST(pp.TermNumber AS STRING), ''),
                coalesce(CAST(pp.PeriodNumber AS STRING), ''),
                coalesce(CAST(pp.EffectiveFrom AS STRING), ''),
                coalesce(CAST(pp.EffectiveTo AS STRING), ''),
                coalesce(pp.StatusCode, ''),
                coalesce(pps.PaymentPlan, ''),
                coalesce(CAST(pps.PremiumAmount AS STRING), ''),
                coalesce(pps.CurrencyCode, ''),
                coalesce(CAST(edf.EffectiveDate AS STRING), ''),
                coalesce(CAST(edf.ExpirationDate AS STRING), '')
            ),
            256
        ) AS hashdiff

    FROM {{ source('gwpc', 'pc_policyperiod_curr') }} pp

    LEFT JOIN {{ source('gwpc', 'pc_paymentplansummary_curr') }} pps
        ON pp.PolicyPublicID = pps.PolicyPublicID
       AND pp.PublicID = pps.PolicyPublicID
       AND COALESCE(pps.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pc_effectivedatedfields_curr') }} edf
        ON pp.PublicID = edf.ObjectPublicID

    WHERE COALESCE(pp.Retired, 0) = 0
      AND COALESCE(TRIM(pp.PublicID), '') <> ''
),

deduplicated AS (

    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY policy_hk, hashdiff
                ORDER BY load_dts DESC
            ) AS rn
        FROM source_data
    )
    WHERE rn = 1
)

SELECT
    policy_hk,
    policy_number,
    term_number,
    period_number,
    policy_effective_ts,
    policy_expiration_ts,
    transaction_status_code,
    payment_plan_code,
    payment_plan_premium_amount,
    payment_plan_currency_code,
    effective_date,
    expiration_date,
    insured_legal_name,
    load_dts,
    hashdiff

FROM deduplicated

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} t
    WHERE t.policy_hk = deduplicated.policy_hk
      AND t.hashdiff = deduplicated.hashdiff
)

{% endif %}