{% test meet_target(model) %}
select 1 from (
select count(*) cnt from {{ source('fhir', 'Condition') }} where CodeCodingCode in ({{ target_codes() | join(', ') }})
) where cnt = 0
{% endtest %}