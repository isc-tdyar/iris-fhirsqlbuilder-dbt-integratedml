{% macro iris__get_create_index_sql(relation, index_config) -%}
  {%- set comma_separated_columns = ", ".join(index_config.columns) -%}
  {%- set index_name = index_config.name -%}

  create {% if index_config.unique -%}
    unique
  {%- endif %} index
  "{{ index_name }}"
  on {{ relation }} ({{ comma_separated_columns }})
{%- endmacro %}