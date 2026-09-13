{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_maritalstatus_curr') }}
