var
	jobban_bannedmsg="<font color=red><big><tt>You have been banned from doing this job</tt></big></font>"
	jobban_rank[0][0]
	jobban_runonce	// Updates legacy bans with new info
	jobban_keylist

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