{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_billingmethod_curr') }}
