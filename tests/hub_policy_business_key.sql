select *
from {{ ref('stg_policyperiod') }}
where coalesce(trim(publicid), '') = ''
   or coalesce(trim(policynumber), '') = ''
   or termnumber is null
