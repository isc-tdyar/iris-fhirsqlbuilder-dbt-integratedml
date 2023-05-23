select Subjectreference,DATE(RecordedDate) RecordedDate, CodeCodingCode, CodeCodingDisplay 
from (
    select Subjectreference,
    LAST_VALUE(RecordedDate) over (Partition by Subjectreference) RecordedDate,
    LAST_VALUE(CodeCodingCode) over (Partition by Subjectreference) CodeCodingCode,
    LAST_VALUE(CodeCodingDisplay) over (Partition by Subjectreference) CodeCodingDisplay 
    from {{ source('fhir', 'Condition') }} 
    where CodeCodingCode in ({{ target_codes() | join(', ') }})
    group by Subjectreference, CodeCodingCode, CodeCodingDisplay
) group by Subjectreference order by RecordedDate;