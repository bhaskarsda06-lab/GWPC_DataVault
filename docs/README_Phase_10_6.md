# Phase 10.6 — Production Alerting, Failure Handling & Recovery

## Objective
Define the production alerting, failure-classification, recovery, and incident-response layer for GWPC Data Vault.

This phase is configuration/runbook oriented. It does not require destructive recovery actions.

## What this phase validates
- failure categories and response
- alert severity and routing
- retry rules
- stop/hold conditions
- recovery validation
- post-recovery smoke testing
- incident evidence retention

## Important
Do not put Databricks tokens, passwords, or client secrets into these files.
Use the approved secret-management mechanism.

## Validation
Run:

```cmd
dbt test --target prod --select path:tests/alerting_recovery
```

Expected:

```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```

## Recovery principle

Never use a blind full rebuild as the default recovery action.

Classify the failure first:
1. Infrastructure / transient
2. Authentication / connectivity
3. dbt compilation / deployment
4. Data quality / reconciliation
5. Relationship / referential integrity
6. Performance / timeout

Then apply the corresponding response in the runbook.
