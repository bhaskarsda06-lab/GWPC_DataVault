{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_policy_curr') }}
where retired = 0
