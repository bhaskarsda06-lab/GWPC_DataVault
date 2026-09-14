# Phase 9 Production Go-Live Checklist

## Platform

- [ ] Unity Catalog enabled
- [ ] DEV/TEST/PROD catalogs confirmed
- [ ] SQL warehouse confirmed
- [ ] Workspace configuration confirmed
- [ ] Production Job created through Bundle

## Identity

- [ ] CI/CD service principal created
- [ ] Job Run As service principal created
- [ ] OIDC federation configured
- [ ] GitHub PROD environment protected
- [ ] No production PAT stored in GitHub

## Data access

- [ ] Source read grants approved
- [ ] Target create/modify grants approved
- [ ] Control-table modify grants approved
- [ ] Reader groups approved
- [ ] Ownership assigned to appropriate groups

## DQ / reconciliation

- [ ] DQ catalog approved
- [ ] Severity levels approved
- [ ] Thresholds approved
- [ ] Source-to-target reconciliation approved
- [ ] Exception process approved

## Operations

- [ ] Job notifications configured
- [ ] SLA documented
- [ ] Runbook approved
- [ ] Restart tested
- [ ] Rollback tested
- [ ] Audit monitoring tested
- [ ] Cost monitoring tested

## Release

- [ ] TEST completed
- [ ] Release tag created
- [ ] PROD approval completed
- [ ] Production smoke test completed
- [ ] First production run reconciled
