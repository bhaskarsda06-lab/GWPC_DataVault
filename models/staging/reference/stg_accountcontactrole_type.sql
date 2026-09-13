{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_accountcontactrole_curr') }}
where typecode = 'AccountHolder'
