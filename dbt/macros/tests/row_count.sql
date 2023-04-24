{% test row_count_equals(model, target) %}
select 1 from (
select 
    (select count(*) from {{ model }}) row_count_left,
    (select count(*) from {{ target }}) row_count_right
)
where row_count_left <> row_count_right
{% endtest %}