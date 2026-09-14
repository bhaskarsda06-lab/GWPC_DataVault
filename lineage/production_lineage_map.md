# Production Lineage Map

## Account
`pc_account_curr`
-> `stg_account`
-> `hub_account`
-> `sat_account_core`
-> `sat_account_status`

## Contact
`pc_contact_curr`
-> `stg_contact`
-> `hub_contact`
-> `sat_contact_details`

## Policy
`pc_policy_curr`
-> `stg_policy`
-> `hub_policy`
-> `sat_policy_details`

## Account-Contact
`pc_accountcontact_curr`
-> `stg_accountcontact`
-> `lnk_account_contact`

## Account-Contact Role
`pc_accountcontactrole_curr`
-> `stg_accountcontactrole`
-> `lnk_account_contact_role`
-> `sat_account_contact_role`

## Policy-Account
`stg_policy`
-> `lnk_policy_account`

## Policy-Contact Role / Bridge
`pc_policycontactrole_curr`
-> `stg_policycontactrole`
-> `lnk_policy_contact_role`
-> `bridge_policy_account_contact`

## Evidence
Physical dbt lineage should be confirmed from the deployed project's manifest/DAG and Databricks metadata.
