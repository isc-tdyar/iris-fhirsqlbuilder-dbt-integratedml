{%- set groupBy = "PatientReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(PatientReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'AllergyIntolerance') }}
