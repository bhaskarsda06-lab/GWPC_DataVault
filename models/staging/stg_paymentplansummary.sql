{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pc_paymentplansummary_curr') }}
where retired = 0
