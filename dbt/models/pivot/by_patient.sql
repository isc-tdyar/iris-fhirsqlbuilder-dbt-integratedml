{{
    config(
        indexes=[
            {'name': 'KeyIdx', 'columns': ['Key'], 'unique': True, 'data': ['TargetStartDate', 'TargetEndDate']},
        ]
    )
}}

select 
    Key,
    DATE(DATEADD(year, -{{ var('target-years') }}, TargetDate)) TargetStartDate,
    DATE(DATEADD(month, -{{ var('target-horizon-months') }}, TargetDate)) TargetEndDate,
    "C-263495000",
    "C-424144002",
    "C-103579009",
    "C-186034007",
    "C-125680007"
from (
    select 
        Patient.Key,
        Gender "C-263495000", -- gender
        NVL(RecordedDate, IFNULL("DeceasedDateTime", CURRENT_DATE, DATE("DeceasedDateTime"))) TargetDate,
        {{ age("BirthDate", "DeceasedDateTime") }} "C-424144002", -- age
        {{ race_ethnicity("UsCoreRaceOmbCategoryValueCodingCode") }} "C-103579009", -- race
        {{ race_ethnicity("UsCoreEthnicityOmbCategoryValueCodingCode") }} "C-186034007", -- ethnic
        MaritalStatusCodingCode "C-125680007" -- marital

    from {{ source('fhir', 'Patient') }} Patient
    left join {{ ref('target_patients') }} Target on Target.SubjectReference = Patient.Key
    group by Patient.Key
) where "C-424144002" >= {{ var('minimal-age') }}
