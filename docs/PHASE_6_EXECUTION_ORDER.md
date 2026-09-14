# Phase 6 Execution Order

## 1. Bootstrap controls

Deploy the control-table SQL through the repository-controlled Databricks
deployment process.

## 2. Build Raw Vault

```cmd
dbt build --select tag:hub tag:link tag:satellite --target dev
```

## 3. DQ

```cmd
dbt test --select path:tests --target dev
```

## 4. Reconciliation

Run the reconciliation tests:

```cmd
dbt test --select link_policy_contact_reconciliation hub_reconciliation --target dev
```

If these test names are not defined as generic singular-test names in the
current dbt project, execute the SQL files directly through the agreed
orchestration mechanism.

## 5. Audit

Persist:

- run_id
- stage
- status
- counts
- DQ result
- reconciliation result
- error details

## Production rule

Do not manually execute control SQL as an operational process. It should be
deployed from Git and invoked by the Databricks job/bundle.
