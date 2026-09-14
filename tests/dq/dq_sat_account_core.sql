-- Phase 9.1: Data Quality - Account Core Satellite
SELECT account_hk, hashdiff, load_dts
FROM {{ ref('sat_account_core') }}
WHERE account_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
