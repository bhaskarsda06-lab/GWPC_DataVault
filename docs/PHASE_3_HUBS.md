# Phase 3 - Raw Vault Hubs

## Objective
Create the three Raw Vault Hubs from the validated Phase 2 staging layer.

### Hubs
- hub_account
- hub_contact
- hub_policy

## Business-key rules from the supplied GWPC SQL

### Account
SHA2(CONCAT_WS('|', PublicID, AccountNumber, 'GWPC'), 256)

### Contact
SHA2(CONCAT_WS('|', PublicID, ID, 'GWPC'), 256)

### Policy
SHA2(CONCAT_WS('|', PublicID, PolicyNumber, CAST(TermNumber AS STRING), 'GWPC'), 256)

## Important
This Phase 3 implementation deliberately uses explicit Databricks SHA2/CONCAT_WS
expressions so the hash-key intent matches the supplied legacy SQL.

The original target DDL should not be manually executed. dbt is the deployment
source of truth.

## Commands

```cmd
dbt build --select tag:hub --target dev
dbt test --select path:models/raw_vault/hubs --target dev
```
