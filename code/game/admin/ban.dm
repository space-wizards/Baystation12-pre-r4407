/proc/fullban(mob/M, reason, banner)
	// Ban the mob using as many methods as possible, and then boot them for good measure
	if (!M || !M.key || !M.client) return
	if(!banner)	banner = "Unspecified"
	if(!reason)	reason = "Unspecified"
	var/time = time2text(world.realtime,"DD-MMM-YYYY")
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
	var/time = time2text(world.realtime,"DD-MMM-YYYY")
	var/DBQuery/my_query = dbcon.NewQuery("REPLACE INTO `crban` (`ckey`, `ips`, `reason`, `bannedby`, `time`) VALUES ('[M.ckey]', '[M.client.address]', '[reason]', '[banner]', '[time]' [unban_time ? "'[unban_time]'" : "NULL"]);")
	if(!my_query.Execute())
		messageadmins("\red [my_query.ErrorMsg()]")
		world.log_admin("[my_query.ErrorMsg()]")
	del M


/proc/fullbanclient(client/C, reason, banner)
	// Equivalent to above, but is passed a client
	if (!C) return
	var/time = time2text(world.realtime,"DD-MMM-YYYY")
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
	var/dude
	var/dudeip
	var/DBQuery/key_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ckey='[X.ckey]'")
	var/DBQuery/ip_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ips='[X.address]'")
	if(!key_query.Execute())
		messageadmins("\red [key_query.ErrorMsg()]")
		world.log_admin("[key_query.ErrorMsg()]")
	else
		while(key_query.NextRow())
			var/list/column_data = key_query.GetRowData()
			dude = column_data["ckey"]
	if(!ip_query.Execute())
		messageadmins("\red [ip_query.ErrorMsg()]")
		world.log_admin("[ip_query.ErrorMsg()]")
	else
		while(ip_query.NextRow())
			var/list/column_data = ip_query.GetRowData()
			dudeip = column_data["ip"]
	if(X.ckey == dude  || X.address == dudeip)
		return 1
	else
		return 0
/
proc/isbannedckey(X as text)
	var/DBQuery/key_query = dbcon.NewQuery("SELECT ckey FROM `crban`WHERE ckey='[X]'")
	var/DBQuery/ip_query = dbcon.NewQuery("SELECT ips FROM `crban`WHERE ckey='[X]'")
	var/dude
	var/dudeip
	if(!key_query.Execute())
		messageadmins("\red [key_query.ErrorMsg()]")
		world.log_admin("[key_query.ErrorMsg()]")
	else
		while(key_query.NextRow())
			var/list/column_data = key_query.GetRowData()
			dude = column_data["ckey"]
	if(!ip_query.Execute())
		messageadmins("\red [ip_query.ErrorMsg()]")
		world.log_admin("[ip_query.ErrorMsg()]")
	else
		while(ip_query.NextRow())
			var/list/column_data = ip_query.GetRowData()
			dudeip = column_data["ip"]
	if((dudeip) || (dude == X)) return 1
	else return 0
/proc/unban(key as text, by as text)
	//Unban a key and associated IP address
	var/ckey=ckey(key)
	if (key)
		var/DBQuery/key_query = dbcon.NewQuery("DELETE FROM `crban` WHERE ckey='[ckey]'")
		if(!key_query.Execute())
			world << "[key_query.ErrorMsg()]"
			return 0
		else
			return 1
	return 0
