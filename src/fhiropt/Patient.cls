Class fhiropt.Patient Extends fhir.Patient
{

Index "$OptPatient" [ Extent, Type = bitmap ];

Storage SQL
{
<SQLMap name="$OptPatient">
<Global>^HSF01R.RsrcI</Global>
<Subscript name="1">
<Expression>"ResourceTypeIndex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Patient"</Expression>
</Subscript>
<Type>bitmapextent</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
