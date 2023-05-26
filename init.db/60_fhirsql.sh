#!/usr/bin/env iriscli

Do ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/docker-entrypoint-initdb.d/fhir/", "FHIRSERVER", "/fhir/r4")

zn "HSSYS"

do ##class(HS.HC.FHIRSQL.Utils.Setup).CreateWebApps(,1)

Set sc = ##class(Ens.Config.Credentials).SetCredential("fhir", "fhir", "fhir", 1)

# Clean up, just in case
Do ##class(HS.HC.FHIRSQL.Data.Projection).%KillExtent()
Do ##class(HS.HC.FHIRSQL.Data.Specification).%KillExtent()
Do ##class(HS.HC.FHIRSQL.Data.Analysis).%KillExtent()
Do ##class(HS.HC.FHIRSQL.Data.FHIRRepository).%KillExtent()

# FHIR Repository
Set repo = {"name":"local","hostname":"localhost","port":"52773","credentialsId":"fhir","repositoryURL":"/fhir/r4","sslId" :"","version":1}
Do ##class(HS.HC.FHIRSQL.Data.FHIRRepository).Append(, repo, .reply)
Set repoId = reply.body.id

# Analyse
Set analysis = {"fhirRepositoryId": (repoId), "selectivityPercentage": 100, "version": 1}
Do ##class(HS.HC.FHIRSQL.Utils.FrontEnd).POSTanalysis(analysis, .reply)
Set scanId = reply.body.id
set total = reply.body.total

# Import Transformation
Set stream = ##class(%Stream.FileCharacter).%New()
Set stream.Filename = "/docker-entrypoint-initdb.d/FHIRtoSQLSpec.json"
Set spec = {}.%FromJSONFile("/docker-entrypoint-initdb.d/FHIRtoSQLSpec.json")
Set spec.scanId = scanId
Do ##class(HS.HC.FHIRSQL.Data.Specification).Append("HS.HC.FHIRSQL.Data.Specification", spec, .reply)

# Create Projection
set schema = $system.Util.GetEnviron("IRIS_FHIRSQLSCHEMA")
Set projection = {"fhirRepositoryId": (repoId), "specificationId": (scanId), "packageName": (schema)}
Do ##class(HS.HC.FHIRSQL.Utils.FrontEnd).POSTprojection(projection,.reply)
