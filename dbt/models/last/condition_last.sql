{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    RecordedDate,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'Condition') }} Condition
inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)
inner join {{ ref('by_patient' )}} Patient on Patient.Key = Condition.SubjectReference 
    and DATE(Condition.RecordedDate) between Patient.TargetStartDate and Patient.TargetEndDate

where CodeCodingCode not in (select DISTINCT ReasonCodeCodingCode from {{ ref('encounter_last') }})

group by {{ groupBy }}