PHASE 9.8 - UNIT TESTING & TRANSFORMATION LOGIC VALIDATION

Purpose:
Validate transformation logic at the model level. These tests complement
the structural, DQ, reconciliation, hash-key, duplicate-history and
referential-integrity tests already completed.

Coverage:
- Staging source-to-model field preservation
- Hub business-key mapping
- Link relationship mapping
- Satellite-to-Hub transformation relationship
- Bridge relationship logic

Installation:
Copy:
tests\unit_logic
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\unit_logic

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/unit_logic --target dev

Expected:
PASS=13
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Interpretation:
These tests are singular data tests. A PASS means the query returned zero
records violating the expected transformation rule.

Important:
The tests intentionally validate logic using the current project columns
and established relationships. They do not introduce fields or business
rules that are not present in the current implementation.
