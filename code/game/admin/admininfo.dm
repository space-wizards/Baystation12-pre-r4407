/datum/admininfo
	var/ckey = ""
	var/rank = 0
	var/rankname = ""

/proc/LoadAdmins()
	//Load all the administrators

	var/DBQuery/AdminList = dbcon.NewQuery("SELECT `A`.`CKey`, `A`.`Rank`, `R`.`Desc` FROM `Admins` as `A` INNER JOIN `Ranks` as `R` ON `R`.`Rank` = `A`.`Rank` ORDER BY `A`.`Rank` DESC")
	AdminList.Execute()

	if(AdminList.RowCount() > 0)
		while(AdminList.NextRow())
			var/list/AdminData = AdminList.GetRowData()
			var/datum/admininfo/AdminInfo = new()
			AdminInfo.ckey = AdminData["CKey"]
			AdminInfo.rank = text2num(AdminData["Rank"])
			AdminInfo.rankname = AdminData["Desc"]
			admins += AdminInfo
			world.log << ("ADMIN: [AdminInfo.ckey] = [AdminInfo.rankname] ([AdminInfo.rank])")

	var/found = 0

	for(var/datum/admininfo/AI in admins)
		if(AI.ckey == ckey(config.hostedby))
			found = 1
			break

	if (!found)
		var/datum/admininfo/AdminInfo = new()
		AdminInfo.ckey = config.hostedby
		AdminInfo.rank = 5
		AdminInfo.rankname = "Server Host"
		admins += AdminInfo

/proc/IsAdmin(var/test)
	if (istype(test, /mob))
		var/mob/B = test
		return IsAdmin(B.ckey)
	else if (istype(test, /client))
		var/client/B = test
		return IsAdmin(B.ckey)
	else
		for (var/datum/admininfo/A in admins)
			if (A.ckey == test)
				return 1

/proc/GetAdmin(var/test)
	if (istype(test, /mob))
		var/mob/B = test
		return GetAdmin(B.ckey)
	else if (istype(test, /client))
		var/client/B = test
		return GetAdmin(B.ckey)
	else
		for (var/datum/admininfo/A in admins)
			if (A.ckey == test)
				return A
	return null