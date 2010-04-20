/proc/fullban(mob/M, reason, banner)
	// Ban the mob using as many methods as possible, and then boot them for good measure
	if (!M || !M.key || !M.client) return
	if(!banner)	banner = "Unspecified"
	if(!reason)	reason = "Unspecified"
	var/time = time2text(world.realtime,"YYYY-MM-DD hh:mm:ss")
	var/DBQuery/my_query = dbcon.NewQuery("REPLACE INTO `crban` (`ckey`, `ips`, `reason`, `bannedby`, `time`) VALUES ('[M.ckey]', '[M.client.address]', '[reason]', '[banner]', '[time]');")
	if(!my_query.Execute())
		messageadmins("\red [my_query.ErrorMsg()]")
		world.log_admin("[my_query.ErrorMsg()]")
		return
	del M
/proc/timeban(mob/M, reason,unban_time, banner)
	// Ban the mob using as many methods as possible, and then boot them for good measure
	if (!M || !M.key || !M.client) return
	if(!banner)	banner = "Unspecified"
	if(!reason)	reason = "Unspecified"
	var/time = time2text(world.realtime,"YYYY-MM-DD hh:mm:ss")
	var/DBQuery/my_query = dbcon.NewQuery("REPLACE INTO `crban` (`ckey`, `ips`, `reason`, `bannedby`, `time`) VALUES ('[M.ckey]', '[M.client.address]', '[reason]', '[banner]', '[time]' [unban_time ? "'[unban_time]'" : "NULL"]);")
	if(!my_query.Execute())
		messageadmins("\red [my_query.ErrorMsg()]")
		world.log_admin("[my_query.ErrorMsg()]")
	del M


/proc/fullbanclient(client/C, reason, banner)
	// Equivalent to above, but is passed a client
	if (!C) return
	var/time = time2text(world.realtime,"YYYY-MM-DD hh:mm:ss")
	var/DBQuery/my_query = dbcon.NewQuery("REPLACE INTO `crban` (`ckey`, `ips`, `reason`, `bannedby`, `time`) VALUES ('[C.ckey]', '[C.address]', '[reason]', '[banner]', '[time]',);")
	if(!my_query.Execute())
		messageadmins("\red [my_query.ErrorMsg()]")
		world.log_admin("[my_query.ErrorMsg()]")
	del C

/proc/isbanned(client/X)
	// When given a mob, client, key, or IP address:
	// Returns 1 if that person is banned.
	// Returns 0 if they are not banned.
	// Only considers basic key and IP bans; but that is sufficient for most purposes.
	var/keytest
	var/iptest
	var/DBQuery/key_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ckey='[X.ckey]'")
	var/DBQuery/ip_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ips='[X.address]'")
	if(!key_query.Execute())
		messageadmins("\red [key_query.ErrorMsg()]")
		world.log_admin("[key_query.ErrorMsg()]")
	else
		while(key_query.NextRow())
			var/list/column_data = key_query.GetRowData()
			keytest = column_data["ckey"]
	if(!ip_query.Execute())
		messageadmins("\red [ip_query.ErrorMsg()]")
		world.log_admin("[ip_query.ErrorMsg()]")
	else
		while(ip_query.NextRow())
			var/list/column_data = ip_query.GetRowData()
			iptest = column_data["ips"]
	if(X.ckey == keytest  || X.address == iptest)
		return 1
	else
		return 0
/proc/isbannedadv(key as text,state)
	// State = 1 is key check
	// State = 2 is a ip check
	// Returns 1 if that person is banned.
	// Returns 0 if they are not banned.
	// Only considers basic key and IP bans; but that is sufficient for most purposes.
	if(state == 1)
		var/ckey = ckey(key)
		var/testkey
		var/DBQuery/key_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ckey='[ckey]'")
		if(!key_query.Execute())
			messageadmins("\red [key_query.ErrorMsg()]")
			world.log_admin("[key_query.ErrorMsg()]")
		else
			while(key_query.NextRow())
				var/list/column_data = key_query.GetRowData()
				testkey = column_data["ckey"]
		if(ckey == testkey)
			return 1
		else
			return 0
	if(state == 2)
		var/ip = key
		var/iptest
		var/DBQuery/ip_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ips='[ip]'")
		if(!ip_query.Execute())
			messageadmins("\red [ip_query.ErrorMsg()]")
			world.log_admin("[ip_query.ErrorMsg()]")
		else
			while(ip_query.NextRow())
				var/list/column_data = ip_query.GetRowData()
				iptest = column_data["ips"]
		if(ip == iptest)
			return 1
		else
			return 0
/proc/unban(key as text, by as text)
	//Unban a key and associated IP address
	var/ckey=ckey(key)
	var/bannerkey
	var/bantime
	var/banreason
	var/unbanner
	var/unbantime
	var/time = time2text(world.realtime,"YYYY-MM-DD hh:mm:ss")
	if (key)
		var/DBQuery/save_query = dbcon.NewQuery("SELECT * FROM `crban` WHERE ckey='[ckey]'")
		if(!save_query.Execute())
			world.log_admin("[save_query.ErrorMsg()]")
		else
			while(save_query.NextRow())
				var/list/column_data = save_query.GetRowData()
				bannerkey = column_data["bannedby"]
				bantime = column_data["time"]
				banreason = column_data["reason"]
				unbanner = by
				unbantime = time
		var/DBQuery/save2_query = dbcon.NewQuery("REPLACE INTO `crban_past` (`CKey`,`Banner`,`BanReason`,`BanTime`,`UnbanTime`,`Unbanned`,`Unbanner`) VALUES ('[ckey]','[bannerkey]','[banreason]','[bantime]','[unbantime]','[unbantime]','[unbanner]')")
		if(!save2_query.Execute())
			world.log_admin("[save2_query.ErrorMsg()]")
		var/DBQuery/key_query = dbcon.NewQuery("DELETE FROM `crban` WHERE ckey='[ckey]'")
		if(!key_query.Execute())
			world.log_admin("[key_query.ErrorMsg()]")
			return 0
		else
			return 1
	else
		return 0
/proc/ifmultikey(client/X)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.address == X.address)
				messageadmins("[M.key] and [X] has the same ip address")