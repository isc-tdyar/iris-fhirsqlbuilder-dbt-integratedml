{{ config(materialized='view') }}
{% set tables = ['by_allergy', 'by_condition', 'by_procedure', 'by_observation'] %}

select 
    P.Key,
    p.gender "263495000",
    {% for table in tables %}
        {{ dbt_utils.star(ref(table), except=['Key']) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}

from {{ source('fhir', 'Patient') }}  P

{% for table in tables %}
    join {{ ref(table) }} "{{ table }}" ON ( "{{ table }}".Key = P.Key )
{% endfor %}
