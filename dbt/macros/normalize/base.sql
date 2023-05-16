{%- macro normalize(code, display, gender, age, value_quantity, value_unit, value_string, value_code, value_display) -%}
{%- 
    set fields = {
        'gender': gender,
        'age': age,
        'value_quantity': value_quantity, 
        'value_unit': value_unit, 
        'value_string': value_string, 
        'value_code': value_code, 
        'value_display': value_display,
    } 
-%}
{%- set macro = ml_on_fhir['normalize_' ~ dbt_utils.slugify(code)] -%}
{%- set macro = macro or ml_on_fhir['normalize__default'] -%}
{{ macro(code, display, fields) }}
{%- endmacro -%}

{% macro load_references() %}
{% endmacro %}

{%- macro in_range(stored_value, stored_unit, values) -%}
case 
{% for (expected_unit, low, high) in values %}
when {{ stored_unit }} = '{{ expected_unit }}' and {{ stored_value }} between {{ low }} and {{ high }} then 'normal' 
{%- endfor %}
else 'abnormal' end
{%- endmacro -%}

{%- macro normalize__default(code, display, fields) -%}
{%- if execute -%}{{ print('normalize__default: ' ~ code) }}{% endif %}
IFNULL({{ fields['value_quantity'] }}, NVL({{ fields['value_display'] }}, {{ fields['value_string'] }}), {{ fields['value_quantity'] }} || ' ' || {{ fields['value_unit'] }})
{%- endmacro -%}

{%- macro normalize__8302_2(code, display, fields) -%}
{{ fields['value_quantity'] }}
{%- endmacro -%}

{%- macro normalize__29463_7(code, display, fields) -%}
{{ fields['value_quantity'] }}
{%- endmacro -%}

{%- macro normalize__85318_4(code, display, fields) -%}
case when "ValueString" = 'greater than 2.2' then 'positive' else 'negative' end
{%- endmacro -%}

{%- macro normalize__28245_9(code, display, fields) -%}
case when "ValueString" = 'Severe signs/symptoms' then 'severe' else 'no' end
{%- endmacro -%}

{%- macro normalize__55277_8(code, display, fields) -%}
case when "ValueString" = 'HIV positive' then 'positive' else 'negative' end
{%- endmacro -%}

{%- macro normalize__63513_6(code, display, fields) -%}
"ValueString"
{%- endmacro -%}

{%- macro normalize__75443_2(code, display, fields) -%}
"ValueString"
{%- endmacro -%}

{%- macro normalize__84215_3(code, display, fields) -%}
"ValueString"
{%- endmacro -%}

{%- macro normalize__71802_3(code, display, fields) -%}
case when "ValueString" = 'Patient is homeless' then 'homeless' else null end
{%- endmacro -%}

{%- macro normalize__417181009(code, display, fields) -%}
case when "ValueCodeableConceptCodingCode" = '260385009' then 'negative' else null end
{%- endmacro -%}
