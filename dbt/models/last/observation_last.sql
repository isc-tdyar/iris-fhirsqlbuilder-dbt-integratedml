{{
    config(
        materialized='table',
        indexes=[
            {'columns': ['SubjectReference', 'CodeCodingCode'], 'unique': True},
            {'columns': ['CodeCodingCode']},
        ]
    )
}}

{%- set groupBy = "SubjectReference, CodeCodingCode, CodeCodingDisplay"  -%}

select DISTINCT
    %EXACT(SubjectReference) SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ValueQuantityValue) over (PARTITION by {{ groupBy }}) ValueQuantityValue,
    LAST_VALUE(ValueQuantityUnit) over (PARTITION by {{ groupBy }}) ValueQuantityUnit,
    LAST_VALUE(ValueCodeableConceptCodingCode) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingCode,
    LAST_VALUE(ValueCodeableConceptCodingDisplay) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingDisplay,
    LAST_VALUE(ValueString) over (PARTITION by {{ groupBy }}) ValueString
from {{ source('fhir', 'Observation') }}

inner join {{ ref('synthea_lc_dataset_codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)
