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