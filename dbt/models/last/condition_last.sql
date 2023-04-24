{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ClinicalStatusCodingCode) over (PARTITION by {{ groupBy }}) ClinicalStatusCodingCode
from {{ source('fhir', 'Condition') }}
inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)

where CodeCodingCode not in (select DISTINCT ReasonCodeCodingCode from {{ ref('encounter_last') }})
