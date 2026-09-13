{{ config(materialized='incremental', unique_key='account_hk', tags=['raw_vault','hub']) }}

with source_data as (
    select
        sha2(concat_ws('|', publicid, accountnumber, 'GWPC'), 256) as account_hk,
        publicid as source_system_unique_identifier,
        accountnumber as account_number,
        'GWPC' as source_system_name,
        current_timestamp() as load_dts
    from {{ ref('stg_account') }}
)
select *
from source_data
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} tgt
    where tgt.account_hk = source_data.account_hk
)
{% endif %}
