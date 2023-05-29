Class fhiropt.Encounter Extends (fhir.Encounter, fhiropt.Base)
{

/// Path: Encounter.reasonCode.coding.code
Property ReasonCodeCodingCode As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Encounter.reasonCode.coding.code",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Encounter.reasonCode.coding.display
Property ReasonCodeCodingDisplay As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Encounter.reasonCode.coding.display",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Encounter.subject.reference
Property SubjectReference As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Encounter.subject.reference",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

Index DataIdx On (SubjectReference, ReasonCodeCodingCode, ReasonCodeCodingDisplay) [ Data = PeriodStart ];

Index "$OptEncounter" [ Extent, Type = bitmap ];

Storage SQL
{
<SQLMap name="$OptEncounter">
<Global>^HSF01R.RsrcI</Global>
<Subscript name="1">
<Expression>"ResourceTypeIndex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Encounter"</Expression>
</Subscript>
<Type>bitmapextent</Type>
</SQLMap>
<SQLMap name="DataIdx">
<Data name="PeriodStart">
<Piece>1</Piece>
</Data>
<Global>^fhir.fhirsql.dataidx</Global>
<RowIdSpec name="1">
<Expression>{S5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Encounter"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SubjectReference}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ReasonCodeCodingCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ReasonCodeCodingDisplay}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
