{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_address_curr') }}
