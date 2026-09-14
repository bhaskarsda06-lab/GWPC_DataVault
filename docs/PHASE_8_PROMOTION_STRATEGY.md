# Phase 8 Promotion Strategy

## DEV

```text
feature branch
     |
     v
Pull Request
     |
     v
CI
     |
     v
merge develop
     |
     v
automatic DEV deployment
```

## TEST

```text
approved commit
     |
     v
TEST GitHub Environment
     |
     v
Bundle validate
     |
     v
Bundle deploy
     |
     v
Databricks validation run
```

## PROD

```text
TEST approved
     |
     v
create release tag
     |
     v
PROD protected environment
     |
     v
approval
     |
     v
bundle validate
     |
     v
bundle deploy
     |
     v
Databricks production job
```

## Rollback

Rollback is Git-based:

1. Identify the last known-good release tag.
2. Validate that tag.
3. Deploy that tag to the affected environment.
4. Do not manually edit Data Vault tables to roll back application code.

Data Vault history itself should normally not be deleted during an application
rollback.
