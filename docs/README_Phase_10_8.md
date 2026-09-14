# Phase 10.8 — Production Audit, Lineage & Compliance Evidence

## Objective
Create a production evidence layer for the GWPC Data Vault covering:
- technical audit evidence
- model lineage
- deployment evidence
- test evidence
- compliance control mapping
- evidence retention

## Scope
This phase separates automatically testable technical evidence from organizational evidence such as approvals, access reviews, change tickets, and retention policies.

No production data is modified by the supplied SQL.

## Validation

```cmd
dbt parse --target prod
dbt test --target prod --select path:tests/audit_lineage_compliance
```

Expected:

```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```

## Production evidence
Capture and retain:
- deployment date/time
- Git commit
- dbt version
- Databricks adapter version
- target/catalog/schema
- build result
- test result
- smoke-test result
- operational-test result
- security-test result
- incident/change reference
- approved operator/reviewer

Do not place credentials or access tokens in evidence.
