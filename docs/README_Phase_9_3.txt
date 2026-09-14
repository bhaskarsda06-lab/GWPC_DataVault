PHASE 9.3 - HASH KEY VALIDATION

Purpose:
Validate Data Vault hash-key population and deterministic generation.

Coverage:
- Hub hash keys
- Link hash keys
- Satellite parent hash keys
- Deterministic Account, Contact and Policy Hub hashes
- Deterministic Account/Contact/Policy relationship Link hashes

Installation:
Copy:
tests\hash_key
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\hash_key

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/hash_key --target dev

Expected:
PASS=20
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Important:
The deterministic tests use the project's currently established hash-key formulas:
Account = publicid|accountnumber|GWPC
Contact = publicid|id|GWPC
Policy = publicid|policynumber|termnumber|GWPC
Account Contact = accountpublicid|contactpublicid|GWPC
Account Contact Role = accountpublicid|contactpublicid|rolecode|GWPC
Policy Account = publicid|accountpublicid|GWPC
Policy Contact Role = policypublicid|contactpublicid|rolecode|GWPC

Do not change existing model SQL unless a test fails.
