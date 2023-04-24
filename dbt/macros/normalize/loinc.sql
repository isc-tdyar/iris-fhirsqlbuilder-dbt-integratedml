
{%- macro normalize__88020_3(code, display, fields) -%}
CASE 
WHEN {{ fields['value_code'] }} = 'LA28404-4' then 'classI' 
WHEN {{ fields['value_code'] }} = 'LA28405-1' then 'classII' 
WHEN {{ fields['value_code'] }} = 'LA28406-9' then 'classIII' 
WHEN {{ fields['value_code'] }} = 'LA28407-7' then 'classIV' 
else null
end
{%- endmacro -%} 

{%- macro normalize__88021_1(code, display, fields) -%}
CASE 
WHEN {{ fields['value_code'] }} = 'LA28409-3' then 'minimal' 
WHEN {{ fields['value_code'] }} = 'LA28410-1' then 'modsevere' 
WHEN {{ fields['value_code'] }} = 'LA28411-9' then 'severe' 
else null
end
{%- endmacro -%} 
