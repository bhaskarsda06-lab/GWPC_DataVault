{{ config(materialized='incremental', unique_key='policy_hk', tags=['raw_vault','hub']) }}

with source_data as (
    select
        sha2(concat_ws('|', publicid, policynumber, cast(termnumber as string), 'GWPC'), 256) as policy_hk,
        publicid as source_system_unique_identifier,
        policynumber as policy_number,
        cast(termnumber as string) as term_number,
        'GWPC' as source_system_name,
        current_timestamp() as load_dts
    from {{ ref('stg_policyperiod') }}
)
select *
from source_data
{% if is_incremental() %}
where not exists (
    select 1 from {{ this }} tgt
    where tgt.policy_hk = source_data.policy_hk
)
{% endif %}
