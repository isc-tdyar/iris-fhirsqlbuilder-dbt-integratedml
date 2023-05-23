Class fhiropt.Base [ Abstract ]
{

ClassMethod BuildDataIdx()
{
    If $ClassName() = "Base" {
        Quit $$$OK
    }
    Set rs = ..ExtentFunc()
    Set cnt = 0
    Set queueToken = ""
    Set queue = $System.WorkMgr.%New()
    set ts = $zh 
    While rs.%Next() {
        Set id = rs.ID
		Set statusCode = queue.Queue("##class("_$ClassName()_").%BuildIndices",$ListBuild("DataIdx"),,,,id,id)
        Set cnt = cnt + 1
    }
    Set sc = queue.Sync()
    Set sc = queue.Wait(,.atEnd,0)
    Write !,"Indexed: ",cnt
    Write !,"Elapsed: ",$zh-ts
}

}
