# Rollback Runbook

## Before rollback
1. Stop the downstream schedule/orchestrator.
2. Capture the failed dbt invocation and logs.
3. Record target, catalog, schema, Git commit, and execution timestamp.
4. Identify whether the failure is model logic, source data, infrastructure, or configuration.

## Preferred rollback
Use the organization's approved Git-based deployment rollback:
1. Identify the last known-good commit/tag.
2. Restore that version through the normal CI/CD pipeline.
3. Re-run the approved build and regression suites.
4. Run post-deployment smoke tests.
5. Re-enable scheduling only after validation passes.

## Data Vault caution
Do not manually delete Hub/Link/Satellite history as a first response to a deployment
failure. Investigate the failed model and incremental state first.

## Recovery evidence
Record:
- incident/deployment ID
- failed command
- Git commit
- target/catalog/schema
- affected models
- root cause
- corrective action
- validation result
