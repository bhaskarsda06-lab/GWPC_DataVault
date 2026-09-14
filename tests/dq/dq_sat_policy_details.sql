-- Phase 9.1: Data Quality - Policy Details Satellite
SELECT policy_hk, hashdiff, load_dts
FROM {{ ref('sat_policy_details') }}
WHERE policy_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
