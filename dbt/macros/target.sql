{% macro target_codes() %}
{{ return(var(var('target'))['codes'] | map('string')) }}
{% endmacro %}

{% macro target_columns() %}
{% set columns = [] %}
{% for target in target_codes() %}
{% do columns.append('C-' ~ target) %}
{% endfor %}
{{ return(columns) }}
{% endmacro %}

{% macro target_codes_dataset() %}
{{ return(ref(var(var('target'))['codes-dataset'])) }}
{% endmacro %}
