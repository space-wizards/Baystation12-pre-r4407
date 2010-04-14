/obj/item/weapon/igniter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/weapon/radio/signaler) && !( src.status )))
		var/obj/item/weapon/radio/signaler/S = W
		if (!( S.b_stat ))
			return
		var/obj/item/weapon/assembly/rad_ignite/R = new /obj/item/weapon/assembly/rad_ignite( user )
		S.loc = R
		R.part1 = S
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 52
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/weapon/prox_sensor) && !( src.status )))

		var/obj/item/weapon/assembly/prox_ignite/R = new /obj/item/weapon/assembly/prox_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 52
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/weapon/timer) && !( src.status )))

		var/obj/item/weapon/assembly/time_ignite/R = new /obj/item/weapon/assembly/time_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 52
		R.loc = user
		src.add_fingerprint(user)
	else if ((istype(W, /obj/item/weapon/healthanalyzer) && !( src.status )))

		var/obj/item/weapon/assembly/anal_ignite/R = new /obj/item/weapon/assembly/anal_ignite( user ) // Hehehe anal
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 52
		R.loc = user
		src.add_fingerprint(user)

	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.status = !( src.status )
	if (src.status)
		user.show_message("\blue The igniter is ready!")
	else
		user.show_message("\blue The igniter can now be attached!")
	src.add_fingerprint(user)
	return

/obj/item/weapon/igniter/attack_self(mob/user as mob)

	src.add_fingerprint(user)
	spawn( 5 )
		ignite()
		return
	return

/obj/item/weapon/igniter/proc/ignite()

	if (src.status)
		var/turf/T = src.loc
		if (src.master)
			T = src.master.loc
		if (!( istype(T, /turf) ))
			T = T.loc
		if (!( istype(T, /turf) ))
			T = T.loc
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)
		else
			if (!( istype(T, /turf) ))
				return
		if (T.firelevel < 900000.0)
			T.firelevel = T.poison
	return

/obj/item/weapon/igniter/examine()
	set src in view()

	..()
	if (((get_dist(src, usr) <= 1 || usr.telekinesis == 1) || src.loc == usr))
		if (src.status)
			usr.show_message("The igniter is ready!")
		else
			usr.show_message("The igniter can be attached!")
	return