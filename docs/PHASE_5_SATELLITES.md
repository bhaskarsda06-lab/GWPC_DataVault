# Phase 5 - Data Vault 2.0 Satellites

Phase 5 implements the four descriptive Satellites from the supplied legacy
Satellite SQL:

- `sat_account_core`
- `sat_account_status`
- `sat_contact_details`
- `sat_policy_details`

## Change detection

Each Satellite calculates a deterministic SHA-256 `hashdiff` across its
payload. Incremental loading inserts a row only when the same parent HK and
hashdiff do not already exist.

This preserves Data Vault history: when descriptive attributes change, a new
Satellite row is inserted instead of updating the previous row.

## Parent hubs

- Account Satellites -> `hub_account`
- Contact Satellite -> `hub_contact`
- Policy Satellite -> `hub_policy`

## Mapping decision

The supplied target DDL had `prior_policy_period_state`, while the supplied
Satellite SQL aliases `BasedOnDate` as `prior_policy_period_date`. Phase 5
uses `prior_policy_period_date TIMESTAMP`.

`insured_legal_name` is explicitly populated as NULL because the supplied
source SQL did not provide a source mapping. No business rule is invented.

## AutomateDV

The project can use AutomateDV macros for standardized Data Vault patterns,
but these models retain the explicit hash expressions from the supplied
legacy SQL so the generated hash keys/hashdiffs remain compatible with the
existing business implementation.

## DEV expectation

With the supplied synthetic DEV input, the four Satellites should produce
one initial descriptive row per source business entity/period, subject to
the joins and supplied source data.
