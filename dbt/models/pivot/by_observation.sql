-- depends_on: {{ ref('laboratory_references') }}
{{ config(unique_key="Key") }}

{%- set source = ref('observation_last') -%}
{%- set keyColumn = "DISTINCT BY (SubjectReference) %EXACT(SubjectReference) Key" -%}
{%- set columnCode = 'CodeCodingCode' -%}
{%- set columnValue = 'ValueQuantityValue' -%}
{%- set columnUnit = 'ValueQuantityUnit' -%}
{%- set valuesColumns = ("ValueQuantityValue", "ValueQuantityUnit", "ValueString", "ValueCodeableConceptCodingCode", "ValueCodeableConceptCodingDisplay") -%}
{%- set values = dbt_utils.get_column_values(table=source, column=columnCode) -%}
{%- set laboratory_references = load_laboratory_references() -%}
{# {%- set values = ["39156-5", "2157-6", "48065-7"] -%} #}

select
    %EXACT(SubjectReference) Key,
    {% for code in values %}
    MAX(case when {{ columnCode }} = '{{ dbt.escape_single_quotes(code) }}'
    then 
    {%- if code in laboratory_references %}
    {{ normalize_laboratory_references(laboratory_references[code]) }}
    {% else %}
    {{ normalize(code, "CodeCodingDisplay", "C-263495000", "C-424144002", *valuesColumns) }}
    {% endif -%}
    else NULL end) as {{ adapter.quote('C-' ~ code) }}{% if not loop.last %},{% endif %}
    {% endfor %}
      
from {{ source }}
inner join {{ ref('by_patient') }} on (SubjectReference = Key)
group by SubjectReference
