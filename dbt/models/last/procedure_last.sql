{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay
from {{ source('fhir', 'Procedure') }}
inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)
where CodeCodingCode not in (select DISTINCT ReasonCodeCodingCode from {{ ref('encounter_last') }})
group by {{ groupBy }}