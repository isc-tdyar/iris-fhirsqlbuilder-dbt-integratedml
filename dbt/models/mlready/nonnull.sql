{{ config(materialized='nonnull') }}
{% set target = ref('summary') %}

SELECT id from mlonfhir.summary