{%- set source = ref('allergy_last') -%}
{%- set columnCode = 'CodeCodingCode' -%}
{%- set columnValue = 'ClinicalStatusCodingCode' -%}
{%- set values = dbt_utils.get_column_values(table=source, column=columnCode) -%}

select
    %EXACT(SubjectReference) Key,
    {% for value in values %}
    $LISTGET(%DLIST(DISTINCT 
        case
            when (
                {{ adapter.quote(columnCode) }} = '{{ dbt.escape_single_quotes(value) }}' AND
                {{ adapter.quote(columnValue) }} = 'active'
                )
            then 1
            else NULL
        end
    ), -1) as {{ adapter.quote('C-' ~ value) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
      
from {{ source }}
group by SubjectReference
