SELECT predict.Key,
       predict.predicted,
       predict.probability,
       predict.target,
       {{ dbt_utils.star(ref('summary'), except=['Key', 'target']) }}
from {{ ref('predict') }} predict
join {{ ref('summary')}} summary using (Key)

