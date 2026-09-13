{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_accountstatus_curr') }}
