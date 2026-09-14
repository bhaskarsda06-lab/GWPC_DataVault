PHASE 9.2 - BUSINESS KEY VALIDATION

Purpose:
Validate business-key completeness, uniqueness, staging-to-hub coverage,
and relationship-key quality.

Folder:
tests/business_key/

Installation:
Copy the business_key folder into:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\business_key

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/business_key --target dev

Expected:
PASS=16
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Notes:
- Account business key: stg_account.publicid
- Contact business key: stg_contact.publicid
- Policy Hub business key: stg_policy.policynumber -> hub_policy.policy_number
- Relationship tests validate required relationship keys.
- Do not change existing model SQL unless a test fails.
