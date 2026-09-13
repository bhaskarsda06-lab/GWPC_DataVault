{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_accountcontact_curr') }}
