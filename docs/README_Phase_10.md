# Phase 10 — Production Readiness & Deployment Framework

## Objective
Prepare the GWPC_DataVault dbt + Databricks project for controlled deployment without
changing the already validated Data Vault model logic.

## Scope
1. Environment separation
2. Secret-safe profile configuration
3. Pre-deployment validation
4. CI/CD validation flow
5. Deployment execution
6. Post-deployment smoke tests
7. Failure handling and rollback guidance
8. Operational runbook
9. Production readiness checklist

## Important
- Do not commit Databricks tokens, passwords, or secrets.
- Keep the existing working `profiles.yml` outside source control.
- Review environment/catalog/schema values before production deployment.
- Phase 10 scripts are framework templates; replace placeholders with your organization's
  approved CI/CD secret and deployment mechanism.

## Recommended execution order
1. Review `deployment/phase10_config.yml`
2. Run `deployment/pre_deploy_check.ps1`
3. Run dbt parse/compile
4. Run the existing Phase 8/9 validation suites
5. Deploy only after validation passes
6. Run `deployment/post_deploy_smoke.sql`
7. Record deployment in the operational log

## Phase 10 does not change existing model SQL.
