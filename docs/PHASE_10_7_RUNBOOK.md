# Phase 10.7 Security & Governance Runbook

## 1. Identity
Production execution should use an approved non-human identity such as a service principal/job identity rather than an individual user's personal credential.

## 2. Least privilege
Separate permissions by responsibility:
- ingestion/source access
- dbt transformation execution
- production read access
- production write/DDL access
- administration/security administration

Grant only what is required.

## 3. Environment separation
Development and production must remain separate.

Production target:
`autdbt_vault_prod.autdbtt`

Development target:
`autdbt_vault_dev`

Do not use a development identity to perform unrestricted production administration.

## 4. Secret management
Credentials must come from the approved secret-management mechanism.
Do not commit secrets to:
- profiles.yml
- Git
- SQL
- YAML
- notebooks
- job definitions
- incident tickets

If a credential is exposed, rotate it immediately.

## 5. Production protection
Production data objects should not be writable by ordinary consumers.
Only the approved deployment/job identity and authorized administrators should have write/DDL privileges.

## 6. Governance
Maintain:
- object ownership
- grants
- service identity
- deployment commit
- job/run identity
- audit history
- incident records

## 7. Security review evidence
Capture the output of the approved Unity Catalog/Databricks permission review separately. This package intentionally does not invent expected usernames, groups, or grant names.

## 8. Change control
Permission changes require the organization's approved change process.
