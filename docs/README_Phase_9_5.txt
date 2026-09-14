PHASE 9.5 - REFERENTIAL INTEGRITY & ORPHAN DETECTION

Purpose:
Validate that Raw Vault and Business Vault relationships do not contain
orphaned Hub foreign keys, orphaned Satellite parent keys, or broken Bridge
relationships.

Coverage:
1. Account-Contact Link -> Account/Contact Hubs
2. Account-Contact-Role Link -> Account/Contact Hubs
3. Policy-Account Link -> Policy/Account Hubs
4. Policy-Contact-Role Link -> Policy/Contact Hubs
5. Account Core Satellite -> Account Hub
6. Account Status Satellite -> Account Hub
7. Contact Details Satellite -> Contact Hub
8. Policy Details Satellite -> Policy Hub
9. Account-Contact-Role Satellite -> Account-Contact-Role Link
10. Policy-Contact-Role Satellite -> Policy-Contact-Role Link
11. Policy/Account/Contact Bridge -> source Links
12. Policy/Account/Contact Bridge -> Policy/Account/Contact Hubs

Installation:
Copy:
tests\referential_integrity
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\referential_integrity

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/referential_integrity --target dev

Expected:
PASS=12
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Interpretation:
These are singular data tests. A PASS means the query returned zero
orphaned/broken records.

Design note:
Phase 9.5 focuses on orphan detection at the physical Hub/Link/Satellite/
Bridge relationship level. Some similar referential checks existed in
earlier Phase 8 reconciliation tests; these Phase 9.5 tests are kept under
a unique path/name so the production-quality validation suite can be run
independently.
