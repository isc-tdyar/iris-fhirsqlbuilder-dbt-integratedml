Class fhiropt.Observation Extends fhir.Observation
{

Property CodeCodingCode As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Observation.code.coding.code",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Observation.code.coding.display
Property CodeCodingDisplay As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Observation.code.coding.display",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

/// Path: Observation.subject.reference
Property SubjectReference As %String(COLLATION = "EXACT") [ Calculated, SqlComputeCode = {set {*} = ##class(HS.HC.FHIRSQL.Utils.ResourceCommon).ExtractFHIR({%FHIR},"Observation.subject.reference",,$lb("hl7.fhir.r4.core@4.0.1"))}, SqlComputed ];

Index DataIdx On (SubjectReference, CodeCodingCode, CodeCodingDisplay) [ Data = (ValueQuantityValue, ValueQuantityUnit, ValueCodeableConceptCodingCode, ValueCodeableConceptCodingDisplay, ValueString, EffectiveDateTime), Type = index ];

Storage SQL
{
<SQLMap name="DataIdx">
<Data name="EffectiveDateTime">
<Piece>5</Piece>
</Data>
<Data name="ValueCodeableConceptCodingCode">
<Piece>3</Piece>
</Data>
<Data name="ValueCodeableConceptCodingDisplay">
<Piece>4</Piece>
</Data>
<Data name="ValueQuantityUnit">
<Piece>2</Piece>
</Data>
<Data name="ValueQuantityValue">
<Piece>1</Piece>
</Data>
<Data name="ValueString">
<Piece>5</Piece>
</Data>
<Global>^fhir.fhirsql.dataidx</Global>
<RowIdSpec name="1">
<Expression>{S5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Observation"</Expression>
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
