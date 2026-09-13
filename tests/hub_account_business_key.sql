select *
from {{ ref('stg_account') }}
where coalesce(trim(publicid), '') = ''
   or coalesce(trim(accountnumber), '') = ''
