/obj/item/weapon/weldingtool/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of fuel left!", src, src.name, src.weldfuel)
	return

/obj/item/weapon/weldingtool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/igniter/I = W
	if (status == 0 && istype(W,/obj/item/weapon/screwdriver))
		status = 1
		user << "\blue The welder can now be attached and modified."
	else if (status == 1 && istype(W,/obj/item/weapon/rods))
		var/obj/item/weapon/rods/R = W
		R.amount = R.amount - 1
		if (R.amount == 0)
			del(R)
		status = 2
		welding = 0
		src.force = 3
		src.damtype = "brute"
		name =  "Welder/Rods Assembly"
		icon_state = "welder2"
		s_istate = "welder"
	else if (status == 2 && istype(I,/obj/item/weapon/igniter) && !I.status)
		del(I)
		status = 3
		name = "Welder/Rods/Igniter Assembly"
		icon_state = "welder3"
	else if (status == 3 && istype(W,/obj/item/weapon/screwdriver))
		var/obj/item/weapon/flamethrower/F = new /obj/item/weapon/flamethrower(user)
		if (user.r_hand == src)
			user.u_equip(src)
			user.r_hand = F
		else
			user.u_equip(src)
			user.l_hand = F
		F.layer = 52
		del(src)

		return

/obj/item/weapon/weldingtool/afterattack(O as obj, mob/user as mob)

	if (src.welding)
		src.weldfuel--
		if (src.weldfuel <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "welder"
		var/turf/location = user.loc
		if (!istype(location, /turf))
			return
		location.firelevel = location.poison + 1
	return

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (src.weldfuel <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "welder1"
		spawn() //start fires while it's lit
			src.process()
	else
		user << "\blue Not welding anymore."
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
	return

/obj/item/weapon/weldingtool/var/processing = 0

/obj/item/weapon/weldingtool/proc/process()
	if(src.processing) //already doing this
		return
	src.processing = 1

	while(src.welding)
		var/turf/location = src.loc
		if(istype(location, /mob/))
			var/mob/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc

		if(isturf(location)) //start a fire if possible
			location.firelevel = max(location.firelevel, location.poison + 1)

		sleep(10)
	processing = 0	//we're done