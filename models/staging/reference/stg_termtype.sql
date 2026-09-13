{{ config(materialized='view') }}

select *
from {{ source('gwpc', 'pctl_termtype_curr') }}
