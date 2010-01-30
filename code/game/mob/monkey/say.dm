/mob/monkey/say(message as text)
	message = copytext(sanitize(message), 1, MAX_MESSAGE_LEN)

	if(!message)
		return

	world.log_say("[src.name]/[src.key] : [message]")

	if (src.muted)
		return

	if (src.dead())
		for(var/mob/M in world)
			if (M.dead())
				M << text("<B>[]</B> []: []", src, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
		return
	if(!src.awake())
		return
	if (copytext(message, 1, 2) == "*" && src.awake())
		src.emote(copytext(message, 2, length(message) + 1))
		return
	if(src.sdisabilities & 2)
		return
	if ((!( message ) || istype(src.wear_mask, /obj/item/weapon/clothing/mask/muzzle)))
		return
	var/sentmessage = null	//stupid fix
	if (src.alive())
		var/list/L = list(  )
		var/italics = 0
		var/obj_range = null
		if (findtext(message, ":r") == 1)
			message = copytext(message, 3, length(message) + 1)
			if(src.stuttering)	sentmessage = stutter(message)
			else	sentmessage = message
			if (src.r_hand)
				src.r_hand.talk_into(usr, sentmessage)
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":l") == 1)
			message = copytext(message, 3, length(message) + 1)
			if(src.stuttering)	sentmessage = stutter(message)
			else	sentmessage = message
			if (src.l_hand)
				src.l_hand.talk_into(usr, sentmessage)
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":w") == 1)
			message = copytext(message, 4, length(message) + 1)
			if(src.stuttering)	sentmessage = stutter(message)
			else	sentmessage = message
			L += hearers(1, null)
			italics = 1
			obj_range = 1
		else if (findtext(message, ":i") == 1)
			message = copytext(message, 3, length(message) + 1)
			if(src.stuttering)	sentmessage = stutter(message)
			else	sentmessage = message
			for(var/obj/item/weapon/radio/intercom/I in view(1, null))
				I.talk_into(usr, sentmessage)
			L += hearers(1, null)
			obj_range = 1
			italics = 1
		else
			L += hearers(null, null)
		L -= src
		L += src
		if(src.stuttering)	sentmessage = stutter(message)
		else	sentmessage = message
		if (italics)
			sentmessage = text("<I>[]</I>", sentmessage)
		for(var/mob/M in L)
			if (istype(M, src.type))
				M.show_message(text("<B>[]</B>: []", src, sentmessage), 2)
			else
				M.show_message(text("<B>[]</B> chimpers.", src), 2)
		for(var/obj/O in view(obj_range, null))
			spawn( 0 )
				if (O)
					O.hear_talk(usr, sentmessage)
				return
	return