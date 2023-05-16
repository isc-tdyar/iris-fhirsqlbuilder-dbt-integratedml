{%- set source = ref('encounter_last') -%}
{%- set columnCode = 'ReasonCodeCodingCode' -%}
{%- set values = dbt_utils.get_column_values(table=source, column=columnCode) -%}

select
    %EXACT(SubjectReference) Key,
    {% for value in values %}
    $LISTGET(%DLIST(DISTINCT 
        case
            when (
                {{ adapter.quote(columnCode) }} = '{{ dbt.escape_single_quotes(value) }}'
                )
            then 1
            else NULL
        end
    ), -1) as {{ adapter.quote('C-' ~ value) }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
      
from {{ source }}
inner join {{ ref('by_patient') }} on (SubjectReference = Key)
group by SubjectReference
