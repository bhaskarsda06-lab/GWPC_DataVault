{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_effectivedatedfields_curr') }}
