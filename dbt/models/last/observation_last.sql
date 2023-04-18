{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ValueQuantityValue) over (PARTITION by {{ groupBy }}) ValueQuantityValue,
    LAST_VALUE(ValueQuantityUnit) over (PARTITION by {{ groupBy }}) ValueQuantityUnit,
    LAST_VALUE(ValueCodeableConceptCodingCode) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingCode,
    LAST_VALUE(ValueCodeableConceptCodingDisplay) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingDisplay
from {{ source('fhir', 'Observation') }}
