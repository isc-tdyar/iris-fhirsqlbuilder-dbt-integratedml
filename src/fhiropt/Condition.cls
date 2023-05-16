Class fhiropt.Condition Extends fhir.Condition
{

/// Path: Condition.clinicalStatus.coding.code
Property ClinicalStatusCodingCode As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Condition.clinicalStatus.coding.code",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Condition.code.coding.code
Property CodeCodingCode As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Condition.code.coding.code",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Condition.code.coding.display
Property CodeCodingDisplay As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Condition.code.coding.display",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Condition.subject.reference
Property SubjectReference As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Condition.subject.reference",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

Index DataIdx On (SubjectReference, CodeCodingCode, CodeCodingDisplay) [ Data = ClinicalStatusCodingCode, Type = index ];

Storage SQL
{
<SQLMap name="DataIdx">
<Data name="ClinicalStatusCodingCode">
<Piece>1</Piece>
</Data>
<Global>^fhir.fhirsql.dataidx</Global>
<RowIdSpec name="1">
<Expression>{S5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Condition"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SubjectReference}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CodeCodingCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CodeCodingDisplay}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
