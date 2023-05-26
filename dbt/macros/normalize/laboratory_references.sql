{% macro load_laboratory_references() %}

{% call statement('laboratory_references_loader', fetch_result=true, auto_begin=false )%}
select
    code,name,unit,low,high,gender
from {{ ref('laboratory_references') }}
{%- endcall -%}

{%- set rows = load_result('laboratory_references_loader').data -%}
{%- set values = {} %}
{%- for (code,name,unit,low,high,gender) in rows %}
{% if code not in values %}
{{ values.update({code: []}) }}
{% endif %}
{{ 
    values[code].append({
        "unit": unit,
        "low": low,
        "high": high,
        "gender": gender
    }) 
}}
{%- endfor %}
{{ return(values) }}

{% endmacro %}

{%- macro normalize_laboratory_references(values) -%}
        case 
        {%- for val in values %} 
        when ValueQuantityUnit = '{{ val["unit"] }}' and 
        {%- if val["gender"] %} "C-263495000" = '{{ val["gender"] }}' and {% endif %}
        {%- if not val["low"] %} ValueQuantityValue < {{ val["high"] }}
        {%- elif not val["high"] %} ValueQuantityValue > {{ val["low"] }}
        {%- else %} ValueQuantityValue between {{ val["low"] }} and {{ val["high"] }}
        {%- endif %} then 'normal'
        {%- endfor %} 
        else 'abnormal' end
{%- endmacro -%}