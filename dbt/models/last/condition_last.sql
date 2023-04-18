{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'Condition') }}
