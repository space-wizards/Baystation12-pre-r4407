/mob/ai/say(message as text)
	message = copytext(sanitize(message), 1, MAX_MESSAGE_LEN)
	if(!message)
		return
	world.log_say("[src.name]/[src.key] : [message]")
	if (src.muted)
		return
	var/alt_name = ""
	if (src.dead())
		for(var/mob/M in world)
			if (M.stat == 2)
				M << text("<B>[]</B>[] []: []", src.rname, alt_name, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
		return

	if (!src.awake())
		return
	if (src.alive())
		var/list/L = list(  )
		var/italics = 0
		var/obj_range = null
		if (findtext(message, ":w") == 1)
			message = copytext(message, 3, length(message) + 1)
			L += hearers(1, null)
			obj_range = 1
			italics = 1
		else if (findtext(message, ":i") == 1)
			message = copytext(message, 3, length(message) + 1)
			for(var/obj/item/weapon/radio/intercom/I in view(1, null))
				I.talk_into(usr, message)
			L += hearers(1, null)
			obj_range = 1
			italics = 1
		else if (findtext(message, ":") == 1)
			var/radionum = text2num(copytext(message, 2, 3)) //number after the :, if any
			message = copytext(message, 3, length(message) + 1)
			for(var/obj/item/weapon/radio/intercom/I in view(1, null))
				if (I.number == radionum)
					I.talk_into(usr, message)
			L += hearers(1, null)
			obj_range = 1
			italics = 1
		else
			L += hearers(null, null)
		L -= src
		L += src
		var/turf/T = src.loc
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)
		if (italics)
			message = text("<I>[]</I>", message)
		for(var/mob/M in L)
			M.show_message(text("<B>[]</B>[]: []", src.rname, alt_name, message), 6)
		for(var/obj/O in view(obj_range, null))
			spawn( 0 )
				if (O)
					O.hear_talk(usr, message)
				return
	for(var/mob/M in world)
		if (M.dead())
			M << text("<B>[]</B>[] []: []", src.rname, alt_name, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
	return