-- Phase 9.1: Data Quality - Account Status Satellite
SELECT account_hk, hashdiff, load_dts
FROM {{ ref('sat_account_status') }}
WHERE account_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
