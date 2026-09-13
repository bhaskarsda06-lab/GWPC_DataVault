# Phase 2 File Map

## Root

`dbt_project.yml`
- Main dbt project configuration.

`packages.yml`
- Declares the pinned AutomateDV package.

`profiles.yml.example`
- Template for local Databricks/dbt connection.

## Staging

`models/staging/_sources.yml`
- Declares GWPC source tables.

`models/staging/stg_account.sql`
- Source account filtering.

`models/staging/stg_contact.sql`
- Source contact filtering.

`models/staging/stg_policy.sql`
- Source policy table.

`models/staging/stg_policyperiod.sql`
- Source policy period filtering.

`models/staging/stg_policycontactrole.sql`
- Source policy-contact-role filtering.

Other staging files expose the source/reference tables required by the supplied
Hub, Link and Satellite SQL.

## Tests

`models/staging/schema.yml`
- Basic not-null/uniqueness tests for key source identifiers.
