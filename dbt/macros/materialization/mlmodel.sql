{% materialization mlmodel, default %}
{%- set target_relation = this.incorporate(type='table') %}
{%- set model_name = this.schema ~ '_' ~ this.identifier %}
{% do log('create ml model ' ~ model_name, info=true) %}

{% call statement('drop table', auto_begin=false) -%}
drop table if exists {{ target_relation }} 
{% endcall %}

{% call statement('create table', auto_begin=false) -%}
create table {{ target_relation }}
as {{ compiled_code }};
{% endcall %}

{% call statement('drop model', auto_begin=false) -%}
drop model if exists {{ model_name }}
{%- endcall %}

{% call statement('create model', auto_begin=false) -%}
create model {{ model_name }} predicting ({{ adapter.quote(config.get('predicting')) }})
from {{ target_relation }}
{%- endcall %}

{% call statement('main', auto_begin=false) -%}
train model {{ model_name }}
{%- endcall %}

{{ adapter.commit() }}

{{ return({'relations': [target_relation]}) }}
{% endmaterialization %}