{%- set groupBy = "SubjectReference, ReasonCodeCodingCode, ReasonCodeCodingDisplay"  -%}

select
    SubjectReference,
    ReasonCodeCodingCode,
    ReasonCodeCodingDisplay
from {{ source('fhir', 'Encounter') }} Encounter
inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || ReasonCodeCodingCode = code and ReasonCodeCodingDisplay = name)
inner join {{ ref('by_patient' )}} Patient on Patient.Key = Encounter.SubjectReference 
    and Encounter.PeriodStart between Patient.TargetStartDate and Patient.TargetEndDate
where ReasonCodeCodingCode is not null
group by {{ groupBy }}
