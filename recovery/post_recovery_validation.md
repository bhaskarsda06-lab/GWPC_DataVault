# Post-Recovery Validation

Run after an approved recovery:

```cmd
dbt debug --target prod
dbt parse --target prod
dbt test --target prod --select path:tests/smoke_production
dbt test --target prod --select path:tests/operational
dbt test --target prod --select path:tests/alerting_recovery
dbt test --target prod --select path:tests/security_governance
dbt test --target prod --select path:tests/audit_lineage_compliance
dbt test --target prod --select path:tests/sla_performance
dbt test --target prod --select path:tests/dr_backup
```

Do not close the recovery event until the required validation layers pass.
