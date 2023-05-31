-- depends_on: {{ ref('lhs-lc-ml-codes') }}
-- depends_on: {{ ref('lhs-stroke-ml-codes') }}

{{ 
    config(
        materialized='mlmodel',
        predicting='target',
        indexes=[
            {'name': 'KeyIdx', 'columns': ['Key'], 'unique': True},
            {'name': 'TargetIdx', 'columns': ['target']},
        ]
    ) 
}}

{% set columns = dbt_utils.get_column_values(target_lhs_dataset(), 'code') %}

SELECT
    "Key", "target",
	{%- for col in columns %}
    {{ adapter.quote(modules.re.sub('[ -]+', '_', col)) }}{% if not loop.last %},{% endif -%}
    {% endfor %}
FROM {{ ref('summary') }} WHERE 
	(target = 0 and %ID %FIND %SQL.SAMPLE( '{{unquotedref('summary')}}' , {{var('split-train-pct')}} , {{var('split-seed')}} ))
	OR 
	(target = 1 and %ID %FIND %SQL.SAMPLE( '{{unquotedref('summary')}}' , {{var('split-train-pct')}} , {{var('split-seed')}} ))


