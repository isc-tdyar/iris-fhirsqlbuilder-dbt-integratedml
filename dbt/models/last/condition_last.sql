{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    RecordedDate,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'Condition') }} Condition

inner join {{ target_codes_dataset() }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name) 

inner join {{ ref('by_patient' )}} Patient on Patient.Key = Condition.SubjectReference 
    and DATE(Condition.RecordedDate) between Patient.TargetStartDate and Patient.TargetEndDate

group by {{ groupBy }}