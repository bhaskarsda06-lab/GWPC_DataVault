-- Phase 9.1: Data Quality - Account Contact Role Satellite
SELECT account_contact_role_hk, hashdiff, load_dts
FROM {{ ref('sat_account_contact_role') }}
WHERE account_contact_role_hk IS NULL OR hashdiff IS NULL OR load_dts IS NULL
