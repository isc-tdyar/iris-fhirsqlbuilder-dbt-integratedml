{% macro unquotedref(rel) %}
{%- if not (rel is mapping and rel.get('metadata', {}).get('type', '').endswith('Relation')) -%}
{%- set rel = ref(rel) -%}
{%- endif -%}
{{ return(rel.schema ~ '.' ~ rel.identifier) }}
{% endmacro  %}

{% macro getdoc(el) %}
{{ print('getdoc') }}
{{ print(el) }}
{{ return('test') }}
{% endmacro %}

{% macro code_to_col(codes) %}
{% set result = [] %}
{% for code in codes %}
{% do result.append(modules.re.sub('-', '_', code)) %}
{% endfor %}
{{ return(result) }}
{% endmacro %}