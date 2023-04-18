#!/usr/bin/env iriscli

set namespace = $NAMESPACE
zn "HSLIB"
Do ##class(HS.HC.Util.Installer).InstallFoundation(namespace)
