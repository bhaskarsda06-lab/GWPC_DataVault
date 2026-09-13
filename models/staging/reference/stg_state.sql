{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_state_curr') }}
