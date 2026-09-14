PHASE 9.7 - RECONCILIATION METRICS & COUNT VALIDATION

Purpose:
Validate record-count and relationship-count consistency across the current
Data Vault pipeline without inventing a one-to-one grain where the source
model has a richer grain.

Coverage:
- Source -> Staging: Account, Contact, Policy
- Staging -> Hub: Account, Contact, Policy
- Staging relationships -> Links: four relationship types
- Satellite population sanity checks
- Bridge population reconciliation
- Consolidated core source/staging zero-difference check

Installation:
Copy:
tests\reconciliation_metrics
to:
C:\Users\BhaskarGajjala\Documents\GitHub\GWPC_DataVault\tests\reconciliation_metrics

Run:
1. dbt parse --target dev
2. dbt test --select path:tests/reconciliation_metrics --target dev

Expected:
PASS=14
WARN=0
ERROR=0
SKIP=0
NO-OP=0

Important:
Policy satellite reconciliation is intentionally a population sanity check,
not a direct row-for-row comparison to stg_policy, because the current
Policy Details satellite is sourced from policy-period grain.

Relationship tests compare distinct relationship business keys rather than
raw physical row counts.
