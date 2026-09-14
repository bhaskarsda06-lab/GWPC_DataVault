PHASE 9.4 - DUPLICATE DETECTION & HISTORY VALIDATION

Purpose:
Validate that Data Vault Hubs and Links do not contain duplicate keys and
that Satellites do not create duplicate historical versions for the same
parent hash key and hashdiff.

Coverage:
1. Hub Account business-key uniqueness
2. Hub Contact business-key uniqueness
3. Hub Policy business-key/term uniqueness
4. Link hash-key uniqueness for all four project links
5. Satellite duplicate-history detection for all six satellites
6. Satellite load timestamp presence for all six satellites

Installation:
Copy:
tests\duplicate_history
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\duplicate_history

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/duplicate_history --target dev

Expected:
PASS=20
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Interpretation:
- Duplicate-detection tests return rows when duplicates exist.
- History tests return rows when invalid duplicate history or missing load
  timestamps exist.
- Therefore a PASS means the query returned zero invalid records.

Important:
This phase intentionally does not require one satellite row per Hub key.
Multiple satellite rows for a Hub key are valid Data Vault history.
The duplicate-history rule is parent HK + hashdiff, which detects repeated
versions without incorrectly rejecting legitimate history changes.
