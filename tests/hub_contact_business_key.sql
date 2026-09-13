select *
from {{ ref('stg_contact') }}
where coalesce(trim(publicid), '') = ''
   or id is null
