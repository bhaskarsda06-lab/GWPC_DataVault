# Phase 10.9 — Production SLA, Performance & Capacity Validation

## Objective
Establish a measurable production baseline for the GWPC Data Vault and validate:
- production execution SLA
- model population
- critical object availability
- duplicate/integrity guardrails
- audit timestamp availability
- capacity monitoring approach
- performance evidence collection

## Important
This phase does not invent a performance target from thin air. The supplied SLA template contains placeholders that should be approved by the project owner.

The SQL tests are read-only.

## Validation

```cmd
dbt parse --target prod
dbt test --target prod --select path:tests/sla_performance
```

Expected:

```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```

## Performance baseline

Use the successful production build runtime as the current observed baseline. For the current project history, a production build completed successfully in approximately 4 minutes 42 seconds. Treat that as an observed baseline, not as an approved SLA.

Record future runs and compare:
- total duration
- model duration
- test duration
- failures/retries
- data volume
- warehouse configuration

## Capacity
Track growth in:
- Hub row counts
- Satellite row counts
- Link row counts
- Bridge row counts
- run duration
- warehouse utilization

Do not establish automatic scaling thresholds until they are approved.
