{% macro age(birth_date, death_date) -%}
DATEDIFF(year, {{ birth_date }}, DATE(nvl({{ death_date }}, CURRENT_TIMESTAMP)))
{% endmacro %}
