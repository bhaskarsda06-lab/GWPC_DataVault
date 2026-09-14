# Phase 10 End-to-End Go-Live Procedure

## Gate 1 - Repository

- All Phase 1-9 artifacts merged.
- No placeholder production credentials.
- `dbt deps` succeeds.
- `dbt parse` succeeds.
- `dbt compile` succeeds.
- CI passes.

## Gate 2 - Databricks Bundle

Run from repository root:

```bash
databricks bundle validate -t dev
databricks bundle deploy -t dev
databricks bundle run -t dev gwpc_datavault_production
```

Databricks documents `bundle validate`, `bundle deploy`, and `bundle run`
as the normal bundle lifecycle. citeturn0search0turn0search2

Repeat the deployment pattern for TEST after approval.

## Gate 3 - DEV

Validate:

- source input
- staging
- hubs
- links
- satellites
- DQ
- reconciliation
- control tables

## Gate 4 - TEST

Use the exact approved commit/ref.

Run:

1. Full pipeline
2. DQ
3. Reconciliation
4. Idempotency test
5. Failure/restart tests
6. Schema-change test
7. Rollback test

## Gate 5 - Production release

Use an immutable release tag or approved commit.

Production bundle mode should be configured for production and should use the
approved service-principal run identity. Databricks production deployment
guidance validates production-mode settings and recommends service principals.
citeturn0search1

## Gate 6 - Production smoke test

After the first production run:

- all required objects exist
- row counts are reasonable
- critical DQ = PASS
- reconciliation = PASS
- no orphan links
- no duplicate HKs
- no unexpected null audit columns
- job status = SUCCESS

## Gate 7 - Acceptance

Production is accepted only when all critical gates pass and evidence is
stored with the release.

Do not mark the project production-ready based only on successful code
compilation. A real Databricks workspace execution is required.
