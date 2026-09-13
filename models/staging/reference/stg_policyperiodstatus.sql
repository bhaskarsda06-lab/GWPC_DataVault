{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_policyperiodstatus_curr') }}
