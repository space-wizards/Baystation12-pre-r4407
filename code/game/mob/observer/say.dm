/mob/observer/say(message as text)
	message = copytext(sanitize(message), 1, MAX_MESSAGE_LEN)
	if(!message)
		return
	world.log_say("Ghost/[src.key] : [message]")
	if (src.muted)
		return
	for(var/mob/M in world)
		if (M.dead() && !istype(M, /mob/observer))
			M << text("<B>Ghost</B> ([src.name]): [message]")
	var/list/L = list(  )
	L += hearers(null, null)
	L += src
	var/turf/T = src.loc
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	for(var/mob/M in L)
		if (istype(M, /mob/observer))
			M.show_message(text("<B>Ghost</B> ([src.name]): [message]"), 2)
			continue
		if(prob(50))
			return
		else if(prob (95))
			M.show_message(text("<I>You hear muffled speech... but nothing is there...</I>"))
		else
			M.show_message(stutter(text("<I>[message]</I>")))
