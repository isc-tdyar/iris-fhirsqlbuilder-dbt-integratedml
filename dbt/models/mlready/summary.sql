{{ config(materialized='view') }}
{% set patients = ref('by_patient') %}
{% set tables = ['by_allergy', 'by_condition', 'by_procedure', 'by_encounter', 'by_observation'] %}

select 
    P.Key,
    {{ dbt_utils.star(patients, except=['Key']) }},
    {% for table in tables %}
        -- {{ table }}
        {{ dbt_utils.star(ref(table), except=['Key']) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}

from {{ patients }}  P

{% for table in tables %}
    left join {{ ref(table) }} "{{ table }}" ON ( "{{ table }}".Key = P.Key )
{% endfor %}
