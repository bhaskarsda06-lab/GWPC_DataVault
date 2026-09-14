# Phase 10.8 Runbook

## 1. Technical evidence

Capture:

```cmd
dbt --version
dbt debug --target prod
dbt parse --target prod
dbt ls --target prod
dbt test --target prod --select path:tests/smoke_production
dbt test --target prod --select path:tests/operational
dbt test --target prod --select path:tests/alerting_recovery
dbt test --target prod --select path:tests/security_governance
dbt test --target prod --select path:tests/audit_lineage_compliance
```

For a production deployment, retain the relevant command output in the approved evidence repository.

## 2. Lineage evidence

Document:

Source -> Staging -> Hub/Satellite -> Link -> Bridge

Use `lineage/production_lineage_map.md`.

## 3. Change evidence

For every production release record:
- change/ticket reference
- Git commit
- release/deployment timestamp
- reviewer/approver
- deployment result
- validation result

## 4. Compliance evidence

Use the control matrix as a mapping document. A control is not considered organizationally compliant merely because a dbt test passes.

Examples of process evidence:
- approved access review
- change approval
- incident closure
- retention approval
- security review

## 5. Retention

Store evidence according to the organization's approved retention policy. Do not invent a retention period in this project.
