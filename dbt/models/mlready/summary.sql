{{ 
    config(
        materialized='table',
        indexes=[
            {'name': 'KeyIdx', 'columns': ['Key'], 'unique': True},
        ]
    ) 
}}
{% set patients = ref('by_patient') %}
{% set tables = ['by_allergy', 'by_condition', 'by_procedure', 'by_encounter', 'by_observation'] %}
{% set except = target_columns() %}
{% do except.append('Key') %}

select 
    P.Key,
    -- target-codes
    case when exists (select 1 from {{ ref('target_patients' )}} TargetPatients where TargetPatients.Subjectreference = P.Key) then 1 else 0 end target,
    {# case when 
    {%- for target in target_columns() %}
    {{ adapter.quote(target) }} = 1 {% if not loop.last %}or{% endif -%}
    {% endfor %}
    then 1 else 0 end "target", #}
    -- by_patient
    {{ dbt_utils.star(patients, except=['Key', 'TargetStartDate', 'TargetEndDate']) }},
    {% for table in tables %}
        -- {{ table }}
        {{ dbt_utils.star(ref(table), except=except) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}

from {{ patients }}  P

{% for table in tables %}
    left join {{ ref(table) }} "{{ table }}" ON ( "{{ table }}".Key = P.Key )
{% endfor %}

order by "target" desc
