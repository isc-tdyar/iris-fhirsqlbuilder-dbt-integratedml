select 
    Key,
    DATE(DATEADD(year, -30, TargetDate)) TargetStartDate,
    TargetDate TargetEndDate,
    "C-263495000",
    "C-424144002",
    "C-103579009",
    "C-186034007",
    "C-125680007"
from (
    select 
        Patient.Key,
        Gender "C-263495000", -- gender
        NVL(DATE(PeriodStart), IFNULL("DeceasedDateTime", CURRENT_DATE, DATE("DeceasedDateTime"))) TargetDate,
        {{ age("BirthDate", "DeceasedDateTime") }} "C-424144002", -- age
        {{ race_ethnicity("UsCoreRaceOmbCategoryValueCodingCode") }} "C-103579009", -- race
        {{ race_ethnicity("UsCoreEthnicityOmbCategoryValueCodingCode") }} "C-186034007", -- ethnic
        MaritalStatusCodingCode "C-125680007" -- marital

    from {{ source('fhir', 'Patient') }} Patient
    left join {{ source('fhir', 'Encounter') }} Encounter on Encounter.SubjectReference = Patient.Key and Encounter.ReasonCodeCodingCode = {{ var('target-code') }}
    group by Patient.Key
) where "C-424144002" >= {{ var('minimal-age') }}