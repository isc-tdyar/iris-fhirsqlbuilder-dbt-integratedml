{% test meet_target(model, target_code) %}
select 1 from (
select count(*) cnt from {{ source('fhir', 'Encounter') }} where ReasonCodeCodingCode = {{ target_code }}
) where cnt = 0
{% endtest %}