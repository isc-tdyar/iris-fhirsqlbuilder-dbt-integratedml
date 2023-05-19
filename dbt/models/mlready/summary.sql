{{ config(materialized='view') }}
{% set patients = ref('by_patient') %}
{% set tables = ['by_allergy', 'by_condition', 'by_procedure', 'by_encounter', 'by_observation'] %}
{% set target = 'C-' ~ var('target-code') %}

select 
    P.Key,
    {{ adapter.quote(target) }},
    {{ dbt_utils.star(patients, except=['Key', 'TargetStartDate', 'TargetEndDate']) }},
    {% for table in tables %}
        -- {{ table }}
        {{ dbt_utils.star(ref(table), except=['Key', target]) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}

from {{ patients }}  P

{% for table in tables %}
    left join {{ ref(table) }} "{{ table }}" ON ( "{{ table }}".Key = P.Key )
{% endfor %}

order by {{ adapter.quote(target) }} desc
