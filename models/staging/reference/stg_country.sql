{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_country_curr') }}
