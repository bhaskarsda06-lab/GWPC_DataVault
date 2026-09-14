# Phase 11 — Production Automation, Scheduling & End-to-End Orchestration

## Objective
Automate the production Data Vault 2.0 pipeline so that source ingestion, dbt staging, Raw Vault, Business Vault, validation, operational controls, and evidence collection execute in a controlled sequence.

## Current project assumptions
- dbt target: `prod`
- Databricks adapter is already configured and validated
- Raw Vault + Business Vault models are already implemented
- Phase 10 production controls are already available
- Secrets must never be stored in this package

## Phase 11 principle

Source availability
  -> pre-checks
  -> dbt build
  -> critical validation
  -> operational validation
  -> audit/evidence
  -> success/failure handling

## Safety
The supplied orchestration assets are templates and validation helpers. They do not create or modify a Databricks Job automatically and do not contain credentials.

Create the actual Databricks workflow/job only after reviewing the organization's scheduling, service-principal, retry, notification, concurrency, and SLA requirements.

## Validation command

```cmd
dbt parse --target prod
dbt test --target prod --select path:tests/orchestration
```

Expected:

```text
PASS=8
WARN=0
ERROR=0
SKIP=0
```

## Important
Do not assume a schedule, retry count, notification destination, RPO/RTO, or SLA target until it is approved.
