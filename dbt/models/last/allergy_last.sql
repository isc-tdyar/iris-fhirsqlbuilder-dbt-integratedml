{%- set groupBy = "PatientReference, CodeCodingCode, CodeCodingDisplay"  -%}

select 
    PatientReference SubjectReference,
    RecordedDate,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'AllergyIntolerance') }} AllergyIntolerance

inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)
inner join {{ ref('by_patient' )}} Patient on Patient.Key = AllergyIntolerance.PatientReference 
    and AllergyIntolerance.RecordedDate <= Patient.TargetStartDate

group by {{ groupBy }}