{%- set source = ref('observation_last') -%}
{%- set columnCode = 'CodeCodingCode' -%}
{%- set columnValue = 'ValueQuantityValue' -%}
{%- set columnUnit = 'ValueQuantityUnit' -%}
{%- set values = dbt_utils.get_column_values(table=source, column=columnCode) -%}

select
    %EXACT(SubjectReference) Key,
    {% for value in values %}
    $LISTGET(%DLIST(DISTINCT 
        case
            when {{ columnCode }} = '{{ dbt.escape_single_quotes(value) }}'
            then IFNULL(ValueQuantityValue, ValueCodeableConceptCodingDisplay, ValueQuantityValue || ' ' || ValueQuantityUnit)
            else NULL
        end
    ), -1) as {{ adapter.quote('C-' ~ value) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
      
from {{ source }}
group by SubjectReference
