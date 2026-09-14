# Phase 10.9 Runbook

## 1. Establish baseline

Capture:

```cmd
dbt --version
dbt debug --target prod
dbt parse --target prod
dbt build --target prod
```

Record:
- start time
- end time
- total runtime
- models executed
- tests executed
- errors/warnings
- retries

## 2. SLA evaluation

Compare the observed runtime against the approved SLA target.

Do not use the observed 4m42s build as an official SLA unless the project owner approves it.

## 3. Performance review

Review:
- slowest models
- incremental model behavior
- full-refresh occurrences
- repeated retries
- warehouse availability
- unusual data-volume increases

## 4. Capacity review

Review:
- row-count growth
- storage growth
- query runtime trend
- warehouse utilization
- concurrency
- scheduled job overlap

## 5. Capacity alerting

Define thresholds only after a baseline has been collected.

Recommended categories:
- informational growth
- performance warning
- SLA breach
- capacity risk

## 6. Evidence

Retain:
- job/run ID
- deployment commit
- runtime
- object counts
- test result
- warehouse/job configuration reference
- SLA comparison
- reviewer
