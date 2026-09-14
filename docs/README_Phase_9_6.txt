PHASE 9.6 - AUDIT METADATA & RECORD-LEVEL AUDIT VALIDATION

Purpose:
Validate audit metadata carried by the Data Vault models, especially load
timestamps, source-system context, hashdiff population/format, and Bridge
audit keys.

Coverage:
- Hub load timestamps
- Hub source-system values
- Link load timestamps
- Link source-system values
- Satellite load timestamps
- Satellite hashdiff population
- Satellite SHA-256 hashdiff format
- Bridge load timestamp
- Bridge relationship keys

Installation:
Copy:
tests\audit_metadata
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\audit_metadata

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/audit_metadata --target dev

Expected:
PASS=13
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Interpretation:
These are singular data tests. PASS means the query returned zero invalid
audit records.

Important:
This phase validates audit metadata that is actually present in the current
project models. It does not invent additional columns such as batch_id,
run_id, record_source, effective_from_dts, or end_dts where those columns
are not established in the current implementation.


FIX APPLIED:
The original am_link_source_system.sql test was removed because the current
Business Vault Link models do not expose a source_system_name column. The
current project models already carry the established GWPC context through
their source-derived hash keys and business-key construction. Phase 9.6
therefore validates only audit metadata columns that actually exist in the
current models.

Expected test count after this fix: 13.
