-- Phase 9.1: Data Quality - Policy Contact Role Satellite
SELECT policy_contact_role_hk, hashdiff, load_dts
FROM {{ ref('sat_policy_contact_role') }}
WHERE policy_contact_role_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
