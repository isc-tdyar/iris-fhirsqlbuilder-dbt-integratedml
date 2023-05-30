-- depends_on: {{ ref('synthea-lc-dataset-codes') }}
-- depends_on: {{ ref('synthea-stroke-dataset-codes') }}

{{ 
    config(
        materialized='table',
        indexes=[
            {'name': 'KeyIdx', 'columns': ['Key'], 'unique': True},
            {'name': 'TargetIdx', 'columns': ['target']},
        ]
    ) 
}}

SELECT
	*
FROM {{ ref('summary') }} WHERE 
	(target = 0 and %ID %FIND %SQL.SAMPLE( '{{unquotedref('summary')}}' , 80 ,123 ))
	OR 
	(target = 1 and %ID %FIND %SQL.SAMPLE( '{{unquotedref('summary')}}' , 80 ,123 ))


