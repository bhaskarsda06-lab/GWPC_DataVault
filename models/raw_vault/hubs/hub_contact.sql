{{ config(materialized='incremental', unique_key='contact_hk', tags=['raw_vault','hub']) }}

with source_data as (
    select
        sha2(concat_ws('|', publicid, cast(id as string), 'GWPC'), 256) as contact_hk,
        cast(id as string) as source_system_contact_identifier,
        publicid as source_system_unique_identifier,
        'GWPC' as source_system_name,
        current_timestamp() as load_dts
    from {{ ref('stg_contact') }}
)
select *
from source_data
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} tgt
    where tgt.contact_hk = source_data.contact_hk
)
{% endif %}
