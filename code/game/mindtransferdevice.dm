/*
Mind Holder and Booth By lyndonarmitage1
---
(Meant to be used by Forensics or security)

From the labs of Hagot Irthm at TimeStellar Industries we give you the Mind Holder!
An amazing bit of technology that allows communication with the dead, trapping of dangerous
criminals, resurrection and other fun stuff!

Of course the company doesn't advertise it for all of these. In fact I have a bio for them
somewhere.
Basically its a company dedicated to the preservation of human health, they deal in:
	Cryogenics
		Cryo Cells
	AI
		This project is a result of AI projects and mind storage.
	Implants
		Things like eyes for the blind, control devices for criminals, automatic healers,
		pain supressors etc.
*/

mob/Mind_Holder
	name="Mind Holder"
	icon = 'icons/ss13/power.dmi'
	icon_state = "MindUnit"
	rname = "Mind Holder"
	density=1
	anchored = 1
	var/id = 0 // used to identify with the booth
	Move() // cannot move
	Logout() // dont delete the mob
	Login()
		src.client.screen = null // get rid of anything on the screen
		src.client.perspective = EYE_PERSPECTIVE
		src.client.eye = src

/mob/Mind_Holder/say(message as text)
	message = copytext(sanitize(message), 1, MAX_MESSAGE_LEN)
	if(!message) return
	world.log_say("[src.name]/[src.key] : [message]")
	if (src.muted) return
	var/alt_name = ""
	if (src.stat == 2)
		for(var/mob/M in world)
			if (M.stat == 2)
				M << text("<B>[]</B>[] []: []", src.rname, alt_name, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
		return

	if (src.stat >= 1)
		return
	if (src.stat < 2)
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
		if(ismob(src.loc)) L += src.loc
		if (italics)
			message = text("<I>[]</I>", message)
		for(var/mob/M in L)
			M.show_message(text("<B>[]</B>[]: []", src.rname, alt_name, message), 2)
		for(var/obj/O in view(obj_range, null))
			spawn(0)
				if(O)
					O.hear_talk(usr, message)
	for(var/mob/M in world)
		if (M.stat > 1)
			M << text("<B>[]</B>[] []: []", src.rname, alt_name, (src.stat > 1 ? "\[<I>dead</I> \]" : ""), message)
	return

/obj/machinery/Mind_Transferer
	name = "Mind Transferer Booth"
	icon = 'icons/ss13/Cryogenic2.dmi'
	icon_state = "restruct_0"
	density = 1
	var/locked = 0
	var/mob/occupant = null
	var/mob/Mind_Holder/holder = null
	var/id = 0
	anchored = 1

	attack_hand(/mob/user)
		src.Activate()
	attack_ai(/mob/ai/user)
		src.Activate()

	New()
		..()
		spawn()
			// Link the holder and the booth
			for(var/mob/Mind_Holder/h in world)
				if(h.id == src.id)
					holder = h
					break

	verb

		Activate()
			set src in oview(1)
			if (usr.stat != 0) return
			src.Transfer()

		Eject()
			set src in oview(1)
			if (usr.stat != 0) return
			if(src.occupant)
				src.occupant.loc = src.loc
				var/mob/M = src.occupant
				if (M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src
				src.occupant = null
				src.icon_state = "mind_0"

	proc
		Transfer()
			if(!holder) return
			if(!occupant) return
			var/client/C1 = holder.client // the current client in the holder
			var/client/C2 = occupant.client // the current client in the booth
			var/mob/Mind_Holder/M = new
			if(C2)
				C2.mob = M
				M.key = C2.key
			if(C1)
				if(!occupant.start)
					occupant.start=1
					// in case it wasnt allready as monkey's default as start=0
				C1.mob = occupant
				occupant.key = C1.key
			if(C2)
				holder.client = C2
			holder<<"You swap bodies with [holder]"
			occupant<<"You swap bodies with [occupant]"
			if(holder.client)
				holder.client.perspective = EYE_PERSPECTIVE
				holder.client.eye = holder
				// without this the eye stays on the booth
			del (M)

/obj/machinery/Mind_Transferer/verb/move_inside()
	set src in oview(1)

	if (usr.stat != 0) return
	if (src.occupant)
		usr << "\blue <B>The [src] is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	if(istype(usr,/mob/Mind_Holder))
		usr<<"\blue <b>Cannot enter"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "mind_1"
	for(var/obj/O in src)
		del(O)
	src.add_fingerprint(usr)
	return

/obj/machinery/Mind_Transferer/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if (!istype(G, /obj/item/weapon/grab) || !ismob(G.affecting))
		return
	if (src.occupant)
		user << "\blue <B>The [src] is already occupied!</B>"
		user << output("\blue <B>The [src] is already occupied!</B>", "outputwindow/ic.output")
		return
	if (G.affecting.abiotic())
		user << "\blue <B>Subject cannot have abiotic items on.</B>"
		user << output("\blue <B>Subject cannot have abiotic items on.</B>", "outputwindow/ic.output")
		return
	var/mob/M = G.affecting
	if(istype(M,/mob/Mind_Holder))
		user<<"\blue <b>Cannot put [M] in [src]"
		user<<output("\blue <b>Cannot put [M] in [src]", "outputwindow/ic.output")
		return
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "restruct_1"
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	del(G)
	return

/obj/machinery/Mind_Transferer/relaymove(mob/user as mob)
	if(user.stat) return
	src.Eject() // get them out
	return