{% macro race_ethnicity(code) -%}
CASE
WHEN "{{ code }}" = '2106-3' then 'white'
WHEN "{{ code }}" = '2135-2' THEN 'hispanic'
WHEN "{{ code }}" = '2054-5' THEN 'black'
WHEN "{{ code }}" = '2028-9' THEN 'asian'
WHEN "{{ code }}" = '1002-5' THEN 'native'
WHEN "{{ code }}" = '2076-8' THEN 'hawaiian'
WHEN "{{ code }}" = '2131-1' THEN 'other'
WHEN "{{ code }}" = '2186-5' THEN 'nonhispanic'
ELSE 'other'
END
{% endmacro %}
