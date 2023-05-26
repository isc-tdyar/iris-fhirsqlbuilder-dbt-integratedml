{% macro drop_schema(name) %}
{% if execute %}
{% set name = target.schema ~ (('_' ~ dbt_utils.slugify(name)) if name else '') %}
{{ log('drop schema ' ~ name, info=True) }}
{% do adapter.drop_schema(api.Relation.create(schema=name)) %}
{% endif %}
{% endmacro %}