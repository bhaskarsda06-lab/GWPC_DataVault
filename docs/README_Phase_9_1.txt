PHASE 9.1 - DATA QUALITY FRAMEWORK

Purpose:
Validate fundamental Data Vault data-quality rules for Hubs, Links, and Satellites.

Files:
tests/dq/
- dq_hub_account.sql
- dq_hub_contact.sql
- dq_hub_policy.sql
- dq_link_account_contact.sql
- dq_link_account_contact_role.sql
- dq_link_policy_account.sql
- dq_link_policy_contact_role.sql
- dq_sat_account_core.sql
- dq_sat_account_status.sql
- dq_sat_contact_details.sql
- dq_sat_policy_details.sql
- dq_sat_account_contact_role.sql
- dq_sat_policy_contact_role.sql

Installation:
Copy the dq folder into:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\dq

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/dq --target dev

Expected:
PASS=13
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Important:
These are generic data-quality tests. Do not modify existing model SQL unless a test fails.
