/obj/item/weapon/radio/electropack/examine()
	set src in view()

	..()
	if (((get_dist(src, usr) <= 1 || usr.telekinesis == 1) || src.loc == usr))
		if (src.e_pads)
			usr << "\blue The electric pads are exposed!"
	return

/obj/item/weapon/radio/electropack/attack_paw(mob/user as mob)

	return src.attack_hand(user)
	return

/obj/item/weapon/radio/electropack/attack_hand(mob/user as mob)

	if (src == user.back)
		user << "\blue You need help taking this off!"
		return
	else
		..()
	return

/obj/item/weapon/radio/electropack/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/screwdriver))
		src.e_pads = !( src.e_pads )
		if (src.e_pads)
			user.show_message("\blue The electric pads have been exposed!")
		else
			user.show_message("\blue The electric pads have been reinserted!")
		src.add_fingerprint(user)
	else
		if (istype(W, /obj/item/weapon/clothing/head/helmet))
			var/obj/item/weapon/assembly/shock_kit/A = new /obj/item/weapon/assembly/shock_kit( user )
			W.loc = A
			A.part1 = W
			W.layer = initial(W.layer)
			if (user.client)
				user.client.screen -= W
			if (user.r_hand == W)
				user.u_equip(W)
				user.r_hand = A
			else
				user.u_equip(W)
				user.l_hand = A
			W.master = A
			src.master = A
			src.layer = initial(src.layer)
			user.u_equip(src)
			if (user.client)
				user.client.screen -= src
			src.loc = A
			A.part2 = src
			A.layer = 52
			src.add_fingerprint(user)
			A.add_fingerprint(user)
	return

/obj/item/weapon/radio/electropack/Topic(href, href_list)
	//..()
	if (usr.stat || usr.restrained())
		return
	if (((istype(usr, /mob/human) && ((!( ticker ) || (ticker && ticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(src.master) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf)))))
		usr.machine = src
		if (href_list["freq"])
			src.freq += text2num(href_list["freq"])
			if (round(src.freq * 10, 1) % 2 == 0)
				src.freq += 0.1
			src.freq = min(148.9, src.freq)
			src.freq = max(144.1, src.freq)
		else
			if (href_list["code"])
				src.code += text2num(href_list["code"])
				src.code = round(src.code)
				src.code = min(100, src.code)
				src.code = max(1, src.code)
			else
				if (href_list["power"])
					src.on = !( src.on )
					src.icon_state = text("electropack[]", src.on)
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(308)
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(384)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/weapon/radio/electropack/accept_rad(obj/item/weapon/radio/signaler/R as obj, message)

	if ((istype(R, /obj/item/weapon/radio/signaler) && R.freq == src.freq && R.code == src.code))
		return 1
	else
		return null
	return

/obj/item/weapon/radio/electropack/r_signal()

	//*****
	//world << "electropack \ref[src] got signal: [src.loc] [on]"
	if ((ismob(src.loc) && src.on))

		var/mob/M = src.loc
		var/turf/T = M.loc
		if ((istype(T, /turf) || istype(T, /obj/move)))
			if (M.moved_recently && M.last_move)
				step(M, M.last_move)
		M.show_message("\red <B>You feel a sharp shock!</B>")


		if (M.weakened < 10)
			M.weakened = 10

	if ((src.master && src.wires & 1))
		src.master:r_signal(1)
	return

/obj/item/weapon/radio/electropack/attack_self(mob/user as mob, flag1)

	if (!( istype(user, /mob/human) ))
		return
	user.machine = src
	var/dat = text("<TT><A href='?src=\ref[];power=1'>[]</A><BR>\n<B>Frequency/Code</B> for electropack:<BR>\nFrequency: <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n</TT>", src, (src.on ? "Turn Off" : "Turn On"), src, src, src.freq, src, src, src, src, src.code, src, src)
	user << browse(dat, "window=radio")
	return