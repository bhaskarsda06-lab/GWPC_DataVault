# Rollback and Recovery Guidance

## Do
- preserve Data Vault history
- use version-controlled deployment artifacts
- isolate the failing layer
- restore service using an approved deployment procedure
- validate after recovery

## Do not
- delete production Hub/Satellite/Link tables as a first response
- truncate production vault objects to hide a failure
- blindly rerun a failing data-quality job
- expose credentials in logs or incident tickets

## Recovery validation
After an approved recovery, execute:

```cmd
dbt test --target prod --select path:tests/smoke_production
dbt test --target prod --select path:tests/operational
```
