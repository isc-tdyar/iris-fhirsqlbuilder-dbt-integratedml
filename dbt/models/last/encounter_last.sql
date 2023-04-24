{%- set groupBy = "SubjectReference, ReasonCodeCodingCode, ReasonCodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    ReasonCodeCodingCode,
    ReasonCodeCodingDisplay
from {{ source('fhir', 'Encounter') }}
inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || ReasonCodeCodingCode = code and ReasonCodeCodingDisplay = name)
where ReasonCodeCodingCode is not null
group by {{ groupBy }}
