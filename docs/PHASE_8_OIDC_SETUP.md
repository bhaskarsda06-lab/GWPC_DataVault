# Phase 8 OIDC Setup

Use GitHub Actions workload identity federation instead of a long-lived
Databricks PAT for CI/CD.

## GitHub environment variables

Create environments:

- `dev`
- `test`
- `prod`

For each environment configure:

- `DATABRICKS_HOST`
- `DATABRICKS_CLIENT_ID`

The production environment should have required reviewers / deployment
protection enabled.

## Databricks federation

Create a dedicated service principal for CI/CD and configure a federation
policy whose subject is restricted to the intended GitHub repository and
environment.

For production, the policy should use the production GitHub environment
subject rather than allowing arbitrary repository branches.

## Important

`DATABRICKS_CLIENT_ID` identifies the service principal; it is not itself a
secret. The federation policy determines who can authenticate as that
principal.

Do not store Databricks PATs in GitHub repository secrets for the production
deployment path.
