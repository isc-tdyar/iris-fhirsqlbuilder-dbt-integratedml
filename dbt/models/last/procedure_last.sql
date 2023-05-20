{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    SubjectReference,
    PerformedPeriodStart,
    CodeCodingCode,
    CodeCodingDisplay
from {{ source('fhir', 'Procedure') }} "Procedure"
inner join {{ ref('synthea_stroke_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)
inner join {{ ref('by_patient' )}} Patient on Patient.Key = "Procedure".SubjectReference 
    and DATE("Procedure".PerformedPeriodStart) between Patient.TargetStartDate and Patient.TargetEndDate
where CodeCodingCode not in (select DISTINCT ReasonCodeCodingCode from {{ ref('encounter_last') }})
group by {{ groupBy }}
