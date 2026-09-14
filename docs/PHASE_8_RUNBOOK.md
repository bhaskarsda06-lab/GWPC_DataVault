# Phase 8 CI/CD Runbook

## Pull Request

CI should perform:

```text
checkout
  -> Python setup
  -> dbt install
  -> dbt deps
  -> dbt parse
  -> dbt compile
```

## DEV

Merge to `develop`.

GitHub Actions:

```text
OIDC
  -> bundle validate
  -> bundle deploy
  -> Databricks job
```

## TEST

Use the approved commit/ref.

Validate and deploy the exact commit that was reviewed.

Do not rebuild source code from a different branch during promotion.

## PROD

Use an immutable release tag or explicitly approved commit.

The production GitHub Environment should require approval before deployment.

## Security

Use:

- GitHub OIDC
- Databricks service principals
- protected environments
- least-privilege Unity Catalog grants
- no long-lived PAT in CI/CD
- no credentials committed to Git

## Runner vs production

GitHub Actions is the deployment/control plane.

Databricks is the data execution plane.

The production dbt transformation workload runs in Databricks, not on the
GitHub-hosted runner.
