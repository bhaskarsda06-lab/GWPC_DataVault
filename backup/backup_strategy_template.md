# Production Backup Strategy Template

## Data Vault
Document the approved backup/recovery mechanism for:
- Hubs
- Satellites
- Links
- Bridges
- staging objects where required

## Code
Source code should be recoverable from the approved version-control repository.

## Configuration
Document recovery for:
- dbt project
- packages configuration
- profiles/connection configuration without secrets
- job definitions
- deployment configuration

## Metadata
Document recovery for:
- Unity Catalog metadata
- grants/ownership evidence
- dbt artifacts
- deployment evidence

## Backup verification
For each backup mechanism record:
- frequency
- retention
- last successful backup
- restore test date
- restore owner
- evidence reference

Do not invent values. Obtain them from the actual platform/organization.
