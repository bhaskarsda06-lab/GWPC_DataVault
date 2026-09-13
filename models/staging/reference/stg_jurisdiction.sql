{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_jurisdiction_curr') }}
