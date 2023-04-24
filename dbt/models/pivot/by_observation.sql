{{ config(unique_key="Key") }}
{%- set source = ref('observation_last') -%}
{%- set keyColumn = "DISTINCT BY (SubjectReference) %EXACT(SubjectReference) Key" -%}
{%- set columnCode = 'CodeCodingCode' -%}
{%- set columnValue = 'ValueQuantityValue' -%}
{%- set columnUnit = 'ValueQuantityUnit' -%}
{%- set valuesColumns = ("ValueQuantityValue", "ValueQuantityUnit", "ValueString", "ValueCodeableConceptCodingCode", "ValueCodeableConceptCodingDisplay") -%}
{%- set values = dbt_utils.get_column_values(table=source, column=columnCode) -%}
{# {%- set values = ["21000-5", "18262-6"] -%} #}

select
    %EXACT(SubjectReference) Key,
    {% for value in values %}
    MAX(case when {{ columnCode }} = '{{ dbt.escape_single_quotes(value) }}'
    then {{ normalize(value, "CodeCodingDisplay", "C-263495000", "C-424144002", *valuesColumns) }}
    else NULL end) as {{ adapter.quote('C-' ~ value) }}{% if not loop.last %},{% endif %}
    {% endfor %}
      
from {{ source }}
join {{ ref('by_patient') }} on (SubjectReference = Key)
group by SubjectReference
