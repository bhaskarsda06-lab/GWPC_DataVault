PHASE 9.9 - END-TO-END DATA VAULT VALIDATION & REGRESSION TESTING

Purpose
-------
Validate the integrated Data Vault flow without duplicating the detailed
Phase 8 and Phase 9 controls already completed.

Coverage
--------
1. Staging business-key coverage into Hubs
2. Policy -> Account relationship chain
3. Policy -> Contact relationship chain
4. Account -> Contact relationship chain
5. Core Satellite -> Hub parent chain
6. Business Vault -> Hub parent chain
7. Bridge -> contributing links
8. Critical relationship key population
9. Relationship-key uniqueness
10. Audit timestamp population
11. Satellite hashdiff population
12. Final regression sentinel

Installation
------------
Copy:
    tests\e2e_regression

to:
    C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\e2e_regression

Execution
---------
1. dbt parse --target dev
2. dbt test --select path:tests/e2e_regression --target dev

Expected
--------
PASS=12
WARN=0
ERROR=0
SKIP=0
NO-OP=0

A PASS means the SQL returned zero violating records.

Important
---------
This phase is intentionally an integration/regression layer. It does not
replace the Phase 8/9 DQ, reconciliation, hash-key, duplicate-history,
referential-integrity, audit, or unit-logic suites.
