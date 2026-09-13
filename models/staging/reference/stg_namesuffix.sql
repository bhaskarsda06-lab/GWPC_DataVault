{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_namesuffix_curr') }}
