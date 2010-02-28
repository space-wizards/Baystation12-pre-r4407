////////////////////////////////
/proc/baysay(text as text)
	for(var/mob/M in world)
		if(M && M.client && M.client.holder && M.client.baysay)
			M << "[text]"

/verb/baysay(text as text)
	set src in List
	if(M && M.client && M.client.holder && M.client.baysay)
		baysay(text)
	else
		usr << "You need to be authed by bay12 admins before you can use this"