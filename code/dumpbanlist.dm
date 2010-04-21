mob/verb/dumpbans()
	usr << browse(crban_bannedmsg, "window=crban;file=banmsg.txt;display=0")
	var/dat = ""
	for (var/X in crban_keylist)
		dat += "INSERT INTO `crban` (`ckey`, `ips`, `reason`, `bannedby`, `time`)  VALUES ('[X]', '[crban_keylist[X]]', '[crban_reason[X]]', '[crban_bannedby[X]]', NOW) \n"
	usr << browse(dat, "window=crban;file=bans.txt;display=0")

/*
var
	crban_bannedmsg="<font color=red><big><tt>You have been banned from [world.name]</tt></big></font>"
	crban_preventbannedclients = 0 // Don't enable this, it'll throw null runtime errors due to the convolted way ss13 logs you in
	crban_keylist[0]  // Banned keys and their associated IP addresses
	crban_reason[0]	// Banned key+reason
	crban_time[0]	// Banned key+time
	crban_bannedby[0]	// who banned them
	crban_iplist[0]   // Banned IP addresses
	crban_ipranges[0] // Banned IP ranges
	crban_computerIDs[0] //Banned Computer IDs (Googolplexed)
	crban_unbanned[0] // So we can remove bans (list of ckeys)
	crban_runonce	// Updates legacy bans with new info
*/