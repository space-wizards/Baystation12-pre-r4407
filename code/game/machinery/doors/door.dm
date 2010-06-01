/obj/machinery/door/meteorhit(obj/M as obj)
	src.open()
	return

/obj/machinery/door/Move()
	block_zoning = 0
	OpenWall(src)
	..()
	if (src.density)
		var/turf/location = src.loc
		if (istype(location, /turf))
			location.updatecell = 0
			block_zoning = 1
			CloseWall(src)
	return


/obj/machinery/door/attack_ai(mob/user as mob)
	if(istype(user,/mob/ai))
		var/mob/ai/AI = user
		var/password = get_password()
		if(src.density)
			AI.sendcommand("[password] OPEN",src)
		else
			AI.sendcommand("[password] CLOSE",src)


/obj/machinery/door/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/var/destroying = 0
/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	if (src.operating)
		return
	src.add_fingerprint(user)
	if (istype(I, /obj/item/weapon/chem/beaker))
		if (I:chem.chemicals.Find("thermite") && I:chem.chemicals.len == 1)
			var/obj/item/weapon/chem/beaker/V = I
			var/obj/substance/chemical/S = V:chem.split(20)
			if (S:volume() >= 20)
				var/turf/T = user.loc
				user << "\blue You carefully begin to affix the beaker to the wall."
				sleep (100)
				if ((user.loc == T && user.equipped() == I && !( user.stat )) && istype(src, /turf/station/r_wall))
					user << "\blue You affix the beaker to the wall."
					src.destroying = 1
					del (V)
					if (I)
						del (I)
				return
			else
				user <<"\blue You don't have enough thermite!"
	else if ((istype(I, /obj/item/weapon/weldingtool) && !( src.operating ) && src.density) && destroying)
		var/obj/item/weapon/weldingtool/W = I
		if(W.welding)
			if (W.weldfuel > 2)
				W.weldfuel -= 2
			else
				user << "Need more welding fuel!"
				return
			new /obj/item/weapon/circuitry( src.loc )
			var/obj/item/weapon/cable_coil/R = new /obj/item/weapon/cable_coil( src.loc )
			R.amount = 2
			var/obj/item/weapon/sheet/glass/M = new /obj/item/weapon/sheet/glass( src.loc )
			M.amount = 4
			del(src)
	if (!src.requiresID())
		//don't care who they are or what they have, act as if they're NOTHING
		user = null
	if (src.density && istype(I, /obj/item/weapon/card/emag))
		src.operating = -1
		flick("door_spark", src)
		sleep(6)
		open()
		return 1
	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()
	else if (src.density)
		flick("door_deny", src)
	return

/obj/machinery/door/blob_act()
	if(prob(20))
		if(checkForMultipleDoors())
			var/turf/T = src.loc
			T.updatecell = 1
			T.buildlinks()
		del(src)

/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1.0)
			if(checkForMultipleDoors())
				var/turf/T = src.loc
				T.updatecell = 1
				T.buildlinks()
			del(src)
		if(2.0)
			if(prob(25))
				if(checkForMultipleDoors())
					var/turf/T = src.loc
					T.updatecell = 1
					T.buildlinks()
				del(src)
		if(3.0)
			if(prob(80))
				var/obj/effects/sparks/S = new /obj/effects/sparks(src.loc)
				S.dir = pick(NORTH, SOUTH, EAST, WEST)
				spawn( 0 )
					S.Life()

/obj/machinery/door/New()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		if (src.density && !istype(src, /obj/machinery/door/window))
			T.updatecell = 0
			T.buildlinks()
		else
			T.buildlinks()
	if(world.time > 10)
		block_zoning = 1
		CloseWall(src)
	return

/obj/machinery/door/proc/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick(text("[]doorc0", (src.p_open ? "o_" : null)), src)
	src.icon_state = text("[]door0", (src.p_open ? "o_" : null))
	sleep(15)
	src.density = 0
	sd_SetOpacity(0)
	var/turf/T = src.loc
	if (istype(T, /turf) && checkForMultipleDoors())
		T.updatecell = 1
		OpenDoor(src)
	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/proc/close()
	if (src.operating || locate(/mob) in loc)
		return
	src.operating = 1
	flick(text("[]doorc1", (src.p_open ? "o_" : null)), src)
	src.icon_state = text("[]door1", (src.p_open ? "o_" : null))
	src.density = 1
	if (src.visible)
		sd_SetOpacity(1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.updatecell = 0
		CloseDoor(src)
	sleep(15)
	src.operating = 0
	return

/obj/machinery/door/proc/autoclose()
	var/obj/machinery/door/D = src
	if (istype(D, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = D
		if ((!A.density) && !( A.operating ) && !(A.locked) && !( A.blocked ))
			close()
	else
		if ((!D.density) && !( D.operating ))
			close()

/obj/machinery/door/Bumped(atom/movable/AM as mob|obj)
	if (!( ismob(AM) ))
		return
	if (!ticker)
		return
	if (src.operating)
		return
	if (src.density && src.allowed(AM))
		if(istype(AM,/mob/human))
			var/mob/human/H = AM
			if(H.zombie)
				return
		open()
	return


/obj/machinery/door/identinfo()
	return "DOOR [!src.density ? "OPEN" : "CLOSED"]"

/obj/machinery/door/receivemessage(message,sender)
	if(..())
		return 1
	if (istype(src,/obj/machinery/door/poddoor) || istype(src,/obj/machinery/door/firedoor))
		return 0
	var/command = uppertext(stripnetworkmessage(message))
	var/list/listofcommand = dd_text2list(command," ",null)
	if(listofcommand.len < 2)
		return
	if(check_password(listofcommand[1]))
		if(listofcommand[2] == "OPEN")
			spawn(0)
				open()
				updateIconState()
		else if(listofcommand[2] == "CLOSE")
			spawn(0)
				close()
				updateIconState()
	return 0