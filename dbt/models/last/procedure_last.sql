{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    SubjectReference,
    PerformedPeriodStart,
    CodeCodingCode,
    CodeCodingDisplay
from {{ source('fhir', 'Procedure') }} "Procedure"

inner join {{ target_codes_dataset() }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name) 
        or CodeCodingCode in ({{ target_codes() | join(', ') }})

inner join {{ ref('by_patient' )}} Patient on Patient.Key = "Procedure".SubjectReference 
    and DATE("Procedure".PerformedPeriodStart) between Patient.TargetStartDate and Patient.TargetEndDate

where CodeCodingCode not in (select DISTINCT ReasonCodeCodingCode from {{ ref('encounter_last') }})
group by {{ groupBy }}
