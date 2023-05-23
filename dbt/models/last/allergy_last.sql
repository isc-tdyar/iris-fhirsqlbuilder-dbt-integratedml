{%- set groupBy = "PatientReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    PatientReference SubjectReference,
    RecordedDate,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'AllergyIntolerance') }} AllergyIntolerance

inner join {{ target_codes_dataset() }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name) 

inner join {{ ref('by_patient' )}} Patient on Patient.Key = AllergyIntolerance.PatientReference 
    and DATE(AllergyIntolerance.RecordedDate) <= Patient.TargetStartDate

group by {{ groupBy }}