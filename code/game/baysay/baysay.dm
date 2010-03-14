////////////////////////////////
/mob/var/baysay = 0
/mob/proc/baysay(text as text,var/key)
	for(var/mob/M in world)
		if(M.baysay == 1)
			M << "[key]:[text]"

/mob/verb/Baysay(text as text)
	if(src.baysay == 1)
		baysay(text,usr.key)
	else
		authbay()



/mob/proc/authbay()
	var/list/baysay = dd_file2list("config/baysay.txt")
	if(baysay.Find(src.key,Start=1,End=0))
		src.baysay = 1
		src << "Authed to use baysay"
	else
		src << "Failed to auth you"