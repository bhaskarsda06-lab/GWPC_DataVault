{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_accountcontactrole_curr') }}
where retired = 0
