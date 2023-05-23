{%- set groupBy = "SubjectReference, ReasonCodeCodingCode, ReasonCodeCodingDisplay"  -%}

select
    SubjectReference,
    ReasonCodeCodingCode,
    ReasonCodeCodingDisplay
from {{ source('fhir', 'Encounter') }} Encounter

inner join {{ target_codes_dataset() }} on ('C-' || ReasonCodeCodingCode = code and ReasonCodeCodingDisplay = name) 
        {# or ReasonCodeCodingCode in ({{ target_codes() | join(', ') }}) #}

inner join {{ ref('by_patient' )}} Patient on Patient.Key = Encounter.SubjectReference 
    and DATE(Encounter.PeriodStart) between Patient.TargetStartDate and Patient.TargetEndDate

where ReasonCodeCodingCode is not null
  and ReasonCodeCodingCode not in (select DISTINCT CodeCodingCode from {{ ref('condition_last') }})

group by {{ groupBy }}
