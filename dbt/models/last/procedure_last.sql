{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay
from {{ source('fhir', 'Procedure') }}
group by {{ groupBy }}