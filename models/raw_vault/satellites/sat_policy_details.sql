{{ config(
    materialized='incremental',
    tags=['raw_vault', 'satellite']
) }}

WITH source_data AS (
    SELECT
        sha2(
            concat_ws('|',
                pp.PublicID,
                pp.PolicyNumber,
                CAST(pp.TermNumber AS STRING),
                'GWPC'
            ), 256
        ) AS policy_hk,

        tt.TYPECODE AS policy_term_type_code,
        pp.NewRenewal AS new_renewal_indicator,
        pp.EffectiveDate AS policy_effective_ts,
        pp.ExpirationDate AS policy_expiration_ts,
        j.TYPECODE AS policy_base_state_code,
        bm.TYPECODE AS billing_method_code,
        pps.PaymentPlanName AS payment_plan_name,
        edf.OfferingCode AS product_offering_code,
        ppss.TYPECODE AS transaction_status_code,

        CAST(NULL AS STRING) AS insured_legal_name,

        edf.TransactionPremiumAmount AS policy_transaction_premium_amount,
        edf.TransactionCostAmount AS policy_transaction_cost_amount,
        edf.TotalCostAmount AS policy_total_cost_amount,
        edf.TotalCostCurrency AS policy_total_cost_currency_code,
        edf.TotalPremiumAmount AS total_premium_amount,

        pp.BasedOnID AS prior_policy_period_id,
        pp.BasedOnDate AS prior_policy_period_date,
        pp.PeriodID AS policy_period_id,

        current_timestamp() AS load_dts,

        sha2(
            concat_ws('|',
                coalesce(tt.TYPECODE, ''),
                coalesce(pp.NewRenewal, ''),
                coalesce(CAST(pp.EffectiveDate AS STRING), ''),
                coalesce(CAST(pp.ExpirationDate AS STRING), ''),
                coalesce(j.TYPECODE, ''),
                coalesce(bm.TYPECODE, ''),
                coalesce(pps.PaymentPlanName, ''),
                coalesce(edf.OfferingCode, ''),
                coalesce(ppss.TYPECODE, ''),
                '',
                coalesce(CAST(edf.TransactionPremiumAmount AS STRING), ''),
                coalesce(CAST(edf.TransactionCostAmount AS STRING), ''),
                coalesce(CAST(edf.TotalCostAmount AS STRING), ''),
                coalesce(edf.TotalCostCurrency, ''),
                coalesce(CAST(edf.TotalPremiumAmount AS STRING), ''),
                coalesce(pp.BasedOnID, ''),
                coalesce(CAST(pp.BasedOnDate AS STRING), ''),
                coalesce(pp.PeriodID, '')
            ), 256
        ) AS hashdiff

    FROM {{ source('gwpc', 'pc_policyperiod_curr') }} pp

    LEFT JOIN {{ source('gwpc', 'pctl_termtype_curr') }} tt
        ON pp.TermType = tt.ID
       AND COALESCE(tt.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_jurisdiction_curr') }} j
        ON pp.Jurisdiction = j.ID
       AND COALESCE(j.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_billingmethod_curr') }} bm
        ON pp.BillingMethod = bm.ID
       AND COALESCE(bm.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pc_paymentplansummary_curr') }} pps
        ON pp.PaymentPlanSummaryID = pps.ID
       AND COALESCE(pps.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pctl_policyperiodstatus_curr') }} ppss
        ON pp.Status = ppss.ID
       AND COALESCE(ppss.Retired, 0) = 0

    LEFT JOIN {{ source('gwpc', 'pc_effectivedatedfields_curr') }} edf
        ON pp.BranchID = edf.BranchID
       AND COALESCE(edf.Retired, 0) = 0

    WHERE COALESCE(pp.Retired, 0) = 0
      AND COALESCE(pp.PublicID, '') <> ''
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
    policy_term_type_code,
    new_renewal_indicator,
    policy_effective_ts,
    policy_expiration_ts,
    policy_base_state_code,
    billing_method_code,
    payment_plan_name,
    product_offering_code,
    transaction_status_code,
    insured_legal_name,
    policy_transaction_premium_amount,
    policy_transaction_cost_amount,
    policy_total_cost_amount,
    policy_total_cost_currency_code,
    total_premium_amount,
    prior_policy_period_id,
    prior_policy_period_date,
    policy_period_id,
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
