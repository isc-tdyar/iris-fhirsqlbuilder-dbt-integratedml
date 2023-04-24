select 
    Key,
    Gender "C-263495000", -- gender
    {{ age("BirthDate", "DeceasedDateTime") }} "C-424144002", -- age
    {{ race_ethnicity("UsCoreRaceOmbCategoryValueCodingCode") }} "C-103579009", -- race
    {{ race_ethnicity("UsCoreEthnicityOmbCategoryValueCodingCode") }} "C-186034007", -- ethnic
    MaritalStatusCodingCode "C-125680007" -- marital

from {{ source('fhir', 'Patient') }}