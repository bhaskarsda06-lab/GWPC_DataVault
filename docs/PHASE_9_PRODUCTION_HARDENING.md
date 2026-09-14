# Phase 9 - Production Hardening and Governance

Phase 9 turns the Phase 1-8 implementation into a production-governed
operating model.

## 1. Identity

Production execution uses a dedicated Databricks service principal.

Databricks recommends service principals for production jobs because job
permissions remain stable when individual users leave or change roles.
citeturn0search15turn0search4

## 2. Unity Catalog

Use the hierarchy:

```text
Metastore
  |
  +-- autdbt_vault_dev
  |      |
  |      +-- autdbts
  |
  +-- autdbt_vault_test
  |      |
  |      +-- autdbts
  |
  +-- autdbt_vault_prod
         |
         +-- autdbts
```

Unity Catalog permissions are hierarchical and commonly require `USE CATALOG`
and `USE SCHEMA` in addition to object permissions.
citeturn0search18turn0search1

Prefer groups for human access and service principals for automated execution.
Databricks recommends avoiding direct user grants where possible.
citeturn0search11

## 3. Least privilege

Do not give the production runner account/metastore-admin privileges merely
to make the pipeline work.

Grant only the permissions required by:

- dbt target materializations
- source reads
- control-table writes
- job execution
- approved external integrations

## 4. Secrets

Do not place passwords, tokens, cloud keys, or database credentials in Git.

If a secret is required inside Databricks, govern it through the approved
secret mechanism. Unity Catalog secrets support access control and auditing;
service credentials are preferred for supported external cloud-service
integrations.
citeturn0search5turn0search8

## 5. Monitoring

Monitor:

- job success/failure
- task duration
- repeated failures
- DQ failures
- reconciliation differences
- SLA breaches
- compute/warehouse behavior
- cost

Databricks provides `system.lakeflow` job system tables for historical job
observability and system tables for broader operational monitoring.
citeturn0search2turn0search3

Critical failures should generate operational notifications according to the
approved on-call process. Databricks supports job notifications and SQL
alerts; alert configuration/evaluation history is also available in the
alert system tables.
citeturn0search9turn0search0

## 6. Data quality severity

Use at least:

- CRITICAL - stop the pipeline / block promotion
- HIGH - fail the affected stage
- MEDIUM - continue but alert
- LOW - record for remediation

Thresholds must be business-approved rather than guessed by engineering.

## 7. Schema evolution

Schema changes must go through Git:

```text
change request
 -> metadata/model change
 -> CI
 -> DEV
 -> TEST
 -> approval
 -> PROD
```

Do not manually alter production Data Vault tables outside the deployment
process except through an approved emergency procedure.

## 8. Data Vault history

Do not delete historical Satellite rows as a normal correction technique.
Fix the transformation/source issue and rerun according to the approved
recovery strategy.

## 9. Production acceptance

Production is not ready until:

- actual catalog/schema names are confirmed
- service principals are created
- OIDC federation is tested
- Unity Catalog grants are approved
- source ingestion is confirmed
- SQL warehouse is approved
- DQ thresholds are approved
- reconciliation rules are approved
- SLA is approved
- alerts/on-call are configured
- restart procedure is tested
- rollback procedure is tested
- release approval is completed
