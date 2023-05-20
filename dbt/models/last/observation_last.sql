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

select 
    SubjectReference,
    CodeCodingCode,
    CodeCodingDisplay,
    LAST_VALUE(ValueQuantityValue) over (PARTITION by {{ groupBy }}) ValueQuantityValue,
    LAST_VALUE(ValueQuantityUnit) over (PARTITION by {{ groupBy }}) ValueQuantityUnit,
    LAST_VALUE(ValueCodeableConceptCodingCode) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingCode,
    LAST_VALUE(ValueCodeableConceptCodingDisplay) over (PARTITION by {{ groupBy }}) ValueCodeableConceptCodingDisplay,
    LAST_VALUE(ValueString) over (PARTITION by {{ groupBy }}) ValueString
from {{ source('fhir', 'Observation') }} Observation

inner join {{ ref('synthea-stroke-dataset-codes') }} on ('C-' || CodeCodingCode = code and CodeCodingDisplay = name)

inner join {{ ref('by_patient' )}} Patient on Patient.Key = Observation.SubjectReference 
    and DATE(Observation.EffectiveDateTime) between Patient.TargetStartDate and Patient.TargetEndDate

group by {{ groupBy }}