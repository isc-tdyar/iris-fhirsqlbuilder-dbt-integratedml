#!/usr/bin/env iriscli

Set namespace = $namespace
Set $namespace = "%SYS"

Set resourceName = "%DB_" _ namespace
Set resourceExists = ##class(Security.Resources).Exists(resourceName)
Set:'resourceExists sc = ##class(Security.Resources).Create(resourceName, "The " _ namespace _ " database", , 1)

Set hsDbRole = "%HS_DB_" _ namespace
Set roleExists = ##class(Security.Roles).Exists(hsDbRole)
Set:'roleExists sc = ##class(Security.Roles).Create(hsDbRole, "Complete SQL and object access to database " _ namespace, resourceName _ ":RW")

Do ##class(Config.Namespaces).Get(namespace, .nsprops)

Do ##class(Config.Databases).Get(nsprops("Globals"), .dbprops)
Set db = ##class(SYS.Database).%OpenId(dbprops("Directory"))
Set db.ResourceName = resourceName
Set sc = db.%Save()

Do ##class(Config.Databases).Get(nsprops("Routines"), .dbprops)
Set db = ##class(SYS.Database).%OpenId(dbprops("Directory"))
Set db.ResourceName = resourceName
Set sc = db.%Save()

