var
	jobban_bannedmsg="<font color=red><big><tt>You have been banned from doing this job</tt></big></font>"
	jobban_rank[0][0]
	jobban_runonce	// Updates legacy bans with new info
	jobban_keylist
/*
/client/verb/showban()
	set category = "Debug"
	world <<	"JOBBANS"
	for(var/t in jobban_keylist)
		world << "[t]<br>"
	world << "<br><br> BREAK <br><br>"
	for(var/f in jobban_rank)
		world << "[f]"


/proc/jobban_fullban(mob/M, rank)
	if (!M || !M.key || !M.client) return
	jobban_key(M.ckey, rank)			//does this work? I have no idea!
	if(!jobban_rank.Find(M.ckey, rank))
		jobban_rank.Add(M.ckey, rank)
	jobban_savebanfile()

/proc/jobban_key(key as text,rank as text)
	var/ckey=ckey(key)
	if(!jobban_rank.Find(ckey, rank))
		jobban_rank.Add(ckey, rank)
		jobban_rank[M.ckey] = banner

	var/ckey=ckey(key)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)
	jobban_keylist[ckey] = rank

*/
/proc/jobban_isbanned(X, rank)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((rank && X) in jobban_rank) return 1
	else return 0

/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_full.ban")
	S["job[0]"] >> jobban_rank
	world.log_admin("Loading jobban_rank")
	S["runonce"] >> jobban_runonce

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["job[0]"] << jobban_rank

/proc/jobban_unban(key, rank)
	var/ckey = ckey(key)
	jobban_rank.Remove(rank, ckey)

/proc/jobban_updatelegacybans()
	if(!jobban_runonce)
		world.log_admin("Updating jobbanfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in jobban_rank)
			if(!T)	continue
		jobban_runonce++	//don't run this update again

/*
/proc/jobban_key(key as text,address as text)
	var/ckey=ckey(key)
	crban_unbanned.Remove(ckey)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)







	crban_keylist[ckey] = address*/