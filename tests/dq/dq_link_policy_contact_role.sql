-- Phase 9.1: Data Quality - Policy Contact Role Link
SELECT policy_contact_role_hk, policy_hk, contact_hk
FROM {{ ref('lnk_policy_contact_role') }}
WHERE policy_contact_role_hk IS NULL OR policy_hk IS NULL OR contact_hk IS NULL
