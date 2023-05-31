{% macro unquotedref(rel) %}
{%- if not (rel is mapping and rel.get('metadata', {}).get('type', '').endswith('Relation')) -%}
{%- set rel = ref(rel) -%}
{%- endif -%}
{{ return(rel.schema ~ '.' ~ rel.identifier) }}
{% endmacro  %}
