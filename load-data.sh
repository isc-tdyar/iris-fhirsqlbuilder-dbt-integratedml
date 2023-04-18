#!/bin/bash

docker-compose exec -T iris iriscli <<-'EOF'
do ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("~/ml-on-fhir/data/fhir/_before", $namespace, "/fhir/r4")
do ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("~/ml-on-fhir/data/fhir/data", $namespace, "/fhir/r4")
halt
EOF
