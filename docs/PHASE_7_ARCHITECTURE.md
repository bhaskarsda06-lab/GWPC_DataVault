# Phase 7 - Production Orchestration and Restartability

## Goal

Move from individual dbt model execution to a controlled Databricks workflow
with explicit stage boundaries.

## Execution

```text
GitHub
   |
   | PR / protected deployment
   v
Databricks Bundle
   |
   v
Lakeflow Job
   |
   +--> bootstrap_control
   |
   +--> staging
   |
   +--> hubs
   |
   +--> links
   |
   +--> satellites
   |
   +--> reconciliation / DQ
   |
   +--> finalize
```

Databricks' current Declarative Automation Bundles guidance recommends keeping
the bundle in the repository and deploying the resource definitions as code.
For bundle-managed jobs, the current documentation also recommends using the
bundle's deployed workspace files rather than relying on a separate job
`git_source` for local relative paths.

## Stage boundaries

| Sequence | Stage | Responsibility |
|---:|---|---|
| 1 | bootstrap_control | Control tables |
| 2 | staging | Source normalization |
| 3 | hubs | Business-key hubs |
| 4 | links | Relationship links |
| 5 | satellites | Descriptive history |
| 6 | reconciliation | DQ + reconciliation |
| 7 | finalize | Completion control |

## Restart model

A run gets a unique `run_id`.

Each stage records:

- stage name
- sequence
- status
- attempt number
- start/end timestamps
- rows affected
- error message

If a stage fails, the restart controller identifies the earliest incomplete
stage. A restart should begin from that stage, not blindly rerun the entire
pipeline.

## Important limitation

This package provides the restart-control metadata and deterministic
restart-point query. The actual "resume from stage N" behavior must be wired
into the final Databricks Job deployment after the team's approved restart
operating procedure is finalized.

Do not use a full-refresh as the default recovery mechanism.

## Idempotency

Hubs use business-key/hash-key idempotency.

Links use relationship hash-key idempotency.

Satellites use parent HK + hashdiff change detection.

Therefore a retry can safely re-execute an already attempted dbt stage
without intentionally creating duplicate business history, assuming the
source snapshot and model logic are unchanged.
