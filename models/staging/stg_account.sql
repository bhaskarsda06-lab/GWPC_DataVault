{{ config(materialized='view') }}

select 
from {{ source('gwpc', 'pc_account_curr') }}
where retired = 0
  and coalesce(trim(publicid), '') <> ''
