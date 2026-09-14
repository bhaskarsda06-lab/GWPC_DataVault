# Production Readiness Checklist

## Configuration
- [ ] Production target is defined by the deployment environment.
- [ ] Catalog/schema values are reviewed.
- [ ] No secret is committed to Git.
- [ ] Production credentials are supplied securely.

## Code
- [ ] `dbt deps` succeeds.
- [ ] `dbt parse` succeeds.
- [ ] `dbt compile` succeeds.
- [ ] No unexpected model changes are present.
- [ ] Git commit/tag is identified.

## Validation
- [ ] Phase 8 reconciliation tests pass.
- [ ] Phase 9 DQ tests pass.
- [ ] Business-key tests pass.
- [ ] Hash-key tests pass.
- [ ] Duplicate/history tests pass.
- [ ] Referential-integrity tests pass.
- [ ] Audit metadata tests pass.
- [ ] Reconciliation metrics tests pass.
- [ ] Unit/transformation tests pass.
- [ ] End-to-end regression tests pass.

## Deployment
- [ ] Deployment window approved.
- [ ] Downstream consumers notified if required.
- [ ] Rollback point identified.
- [ ] Logs are retained.
- [ ] Post-deployment smoke test passes.

## Operations
- [ ] Monitoring/alert destination is configured by the organization.
- [ ] Runbook is available to support team.
- [ ] Failure ownership is defined.
