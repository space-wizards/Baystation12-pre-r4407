/obj/machinery/New()
	..()
	machines += src

/obj/machinery/Del()
	machines -= src
	..()

/obj/machinery/dispenser/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				while(src.o2tanks > 0)
					new /obj/item/weapon/tank/oxygentank( src.loc )
					src.o2tanks--
				while(src.pltanks > 0)
					new /obj/item/weapon/tank/plasmatank( src.loc )
					src.pltanks--
		else
	return

/obj/machinery/dispenser/blob_act()
	if (prob(25))
		while(src.o2tanks > 0)
			new /obj/item/weapon/tank/oxygentank( src.loc )
			src.o2tanks--
		while(src.pltanks > 0)
			new /obj/item/weapon/tank/plasmatank( src.loc )
			src.pltanks--
		del(src)

/obj/machinery/dispenser/meteorhit()
	while(src.o2tanks > 0)
		new /obj/item/weapon/tank/oxygentank( src.loc )
		src.o2tanks--
	while(src.pltanks > 0)
		new /obj/item/weapon/tank/plasmatank( src.loc )
		src.pltanks--
	del(src)
	return

/obj/machinery/dispenser/process()
	return

/obj/machinery/dispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/dispenser/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.machine = src
	var/dat = text("<TT><B>Loaded Tank Dispensing Unit</B><BR>\n<FONT color = 'blue'><B>Oxygen</B>: []</FONT> []<BR>\n<FONT color = 'orange'><B>Plasma</B>: []</FONT> []<BR>\n</TT>", src.o2tanks, (src.o2tanks ? text("<A href='?src=\ref[];oxygen=1'>Dispense</A>", src) : "empty"), src.pltanks, (src.pltanks ? text("<A href='?src=\ref[];plasma=1'>Dispense</A>", src) : "empty"))
	user << browse(dat, "window=dispenser")
	return

/obj/machinery/dispenser/Topic(href, href_list)
	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained())
		return
	if (!(istype(usr, /mob/human) || ticker))
		if (!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
		else
			usr << "\red You are unable to dispense anything, since the controls are physical levers which don't go through any other kind of input."
		return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["oxygen"])
			if (text2num(href_list["oxygen"]))
				if (src.o2tanks > 0)
					use_power(5)
					new /obj/item/weapon/tank/oxygentank( src.loc )
					src.o2tanks--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		else
			if (href_list["plasma"])
				if (text2num(href_list["plasma"]))
					if (src.pltanks > 0)
						use_power(5)
						new /obj/item/weapon/tank/plasmatank( src.loc )
						src.pltanks--
				if (istype(src.loc, /mob))
					attack_hand(src.loc)
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
	else
		usr << browse(null, "window=dispenser")
		return
	return

/obj/item/weapon/clothing/burn(fi_amount)
	if (fi_amount > src.s_fire)
		spawn( 0 )
			var/t = src.icon_state
			src.icon_state = ""
			src.icon = 'b_items.dmi'
			flick(text("[]", t), src)
			spawn(14)
				del(src)
				return
			return
		return 0
	return 1

/obj/item/weapon/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/weapon/clothing/shoes/orange/attack_self(mob/user as mob)
	if (src.chained)
		src.chained = null
		new /obj/item/weapon/handcuffs( user.loc )
		src.icon_state = "o_shoes"
	return

/obj/item/weapon/clothing/shoes/orange/attackby(H as obj, loc)
	if ((istype(H, /obj/item/weapon/handcuffs) && !( src.chained )))
		//H = null
		del(H)
		src.chained = 1
		src.icon_state = "o_shoes1"
	return

/obj/item/weapon/clothing/mask/muzzle/attack_paw(mob/user as mob)
	if (src == user.wear_mask)
		return
	else
		..()
	return

/obj/item/weapon/tank/blob_act()
	if(prob(25))
		var/turf/T = src.loc
		if (!( istype(T, /turf) ))
			return
		if(src.gas)
			src.gas.turf_add(T, -1.0)
		del(src)

/obj/item/weapon/tank/attack_self(mob/user as mob)
	user.machine = src
	if (!( src.gas ))
		return
	var/dat = text("<TT><B>Tank</B><BR>\n<FONT color = 'blue'><B>Contains/Capacity</B> [] / []</FONT><BR>\nInterals Valve: <A href='?src=\ref[];stat=1'>[] Gas Flow</A><BR>\n\t<A href='?src=\ref[];cp=-50'>-</A> <A href='?src=\ref[];cp=-5'>-</A> <A href='?src=\ref[];cp=-1'>-</A> [] <A href='?src=\ref[];cp=1'>+</A> <A href='?src=\ref[];cp=5'>+</A> <A href='?src=\ref[];cp=50'>+</A><BR>\n<BR>\n<A href='?src=\ref[];mach_close=tank'>Close</A>\n</TT>", src.gas.tot_gas(), src.maximum, src, ((src.loc == user && user.internal == src) ? "Stop" : "Restore"), src, src, src, src.i_used, src, src, src, user)
	user << browse(dat, "window=tank;size=600x300")
	return

/obj/item/weapon/tank/Topic(href, href_list)
	..()
	if (usr.stat|| usr.restrained())
		return
	if (src.loc == usr)
		usr.machine = src
		if (href_list["cp"])
			var/cp = text2num(href_list["cp"])
			src.i_used += cp
			src.i_used = min(max(round(src.i_used), 0), 10000)
		if ((href_list["stat"] && src.loc == usr))
			if (usr.internal != src && usr.wear_mask && (usr.wear_mask.flags & MASKINTERNALS))
				usr.internal = src
				usr << "\blue Now running on internals!"
			else
				if(usr.internal)
					usr << "\blue No longer running on internals!"
				usr.internal = null
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src.loc))
			if ((M.client && M.machine == src))
				src.attack_self(M)
	else
		usr << browse(null, "window=tank")
		return
	return

/obj/item/weapon/tank/proc/process(mob/M as mob, obj/substance/gas/G as obj)
	var/amount = src.i_used
	var/total = src.gas.tot_gas()
	if (amount > total)
		amount = total
	if (total > 0)
		G.transfer_from(src.gas, amount)
	return G

/obj/item/weapon/tank/attack(mob/M as mob, mob/user as mob)
	..()
	if ((prob(30) && M.stat < 2))
		var/mob/human/H = M

// ******* Check

		if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.stunned < time)
				M.stunned = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if ((O.client && !( O.blinded )))
				O << text("\red <B>[] has been knocked unconscious!</B>", M)
		M << text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120)
	return

/obj/item/weapon/tank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/icon = src
	if (istype(src.loc, /obj/item/weapon/assembly))
		icon = src.loc
	if (istype(W, /obj/item/weapon/analyzer) && get_dist(user, src) <= 1)
		for (var/mob/O in viewers(user, null))
			O << "\red [user] has used the analyzer on \icon[icon]"
			var/total = src.gas.tot_gas()
			var/t1 = 0
			user << "\blue Results of analysis of \icon[icon]"
			if (total)
				user << "\blue Overall: [total] / [src.gas.maximum]"
				t1 = round( src.gas.n2 / total * 100 , 0.0010)
				user << "\blue Nitrogen: [t1]%"
				t1 = round( src.gas.oxygen / total * 100 , 0.0010)
				user << "\blue Oxygen: [t1]%"
				t1 = round( src.gas.plasma / total * 100 , 0.0010)
				user << "\blue Plasma: [t1]%"
				t1 = round( src.gas.co2 / total * 100 , 0.0010)
				user << "\blue CO2: [t1]%"
				t1 = round( src.gas.sl_gas / total * 100 , 0.0010)
				user << "\blue N2O: [t1]%"
				user << text("\blue Temperature: []&deg;C", src.gas.temperature-T0C)
			else
				user << "\blue Tank is empty!"
		src.add_fingerprint(user)
	return

/obj/item/weapon/tank/New()
	..()
	src.gas = new /obj/substance/gas( src )
	src.gas.maximum = src.maximum
	return

/obj/item/weapon/tank/Del()
	//src.gas = null
	del(src.gas)
	..()
	return

/obj/item/weapon/tank/burn(fi_amount)
	if(src.gas)
		if ( (fi_amount * src.gas.tot_gas()) > (src.maximum * 3.75E7) )
			src.gas.turf_add(get_turf(src.loc), src.gas.tot_gas())
		//SN src = null
			del(src)
			return
	return

/obj/item/weapon/tank/examine()
	var/obj/item/weapon/icon = src
	if (istype(src.loc, /obj/item/weapon/assembly))
		icon = src.loc
		if (get_dist(src, usr) > 1)
			if (icon == src) usr << "\blue It's a \icon[icon]! If you want any more information you'll need to get closer."
			return
		var/foo = src.gas.temperature-T0C
		if (foo < 20)
			foo = "cold"
		else if (foo == 20)
			foo = "room temperature"
		else if (foo > 20 && foo < 300)
			foo = "lukewarm"
		else if (foo >= 300 && foo < 450)
			foo = "warm"
		else if (foo >= 450 && foo < 500)
			foo = "hot"
		else
			foo = "dangerously hot"
		usr << text("\blue The \icon[] feels []", icon, foo)
	return

/obj/item/weapon/tank/oxygentank/New()
	..()
	src.gas.oxygen = src.maximum
	return

/obj/item/weapon/tank/jetpack/New()
	..()
	src.gas.oxygen = src.maximum
	return

/obj/item/weapon/tank/jetpack/verb/toggle()
	src.on = !( src.on )
	src.icon_state = text("jetpack[]", src.on)
	return

/obj/item/weapon/tank/jetpack/proc/allow_thrust(num, mob/user as mob)
	if (!( src.on ))
		return 0
	if ((num < 1 || src.gas.tot_gas() < num))
		return 0
	var/obj/substance/gas/G = new /obj/substance/gas(  )
	G.transfer_from(src.gas, num)
	if (G.oxygen >= 100)
		return 1
	if (G.plasma > 10)
		if (user)
			var/d = G.plasma / 2
			d = min(abs(user.health + 100), d, 25)
			user.fireloss += d
			user.updatehealth()
		return (G.oxygen >= 75 ? 0.5 : 0)
	else
		if (G.oxygen >= 75)
			return 0.5
		else
			return 0
	//G = null
	del(G)
	return

/obj/item/weapon/tank/anesthetic/New()
	..()
	src.gas.sl_gas = 700000
	src.gas.oxygen = 1000000
	return

/obj/item/weapon/tank/plasmatank/proc/release()
	var/turf/T = get_turf(src.loc)
	T.poison += src.gas.plasma * src.gas.temperature / 25.0
	T.oxygen += src.gas.oxygen * src.gas.temperature / 25.0
	T.n2 += src.gas.n2 * src.gas.temperature / 25.0
	T.sl_gas += src.gas.sl_gas * src.gas.temperature / 25.0
	T.res_vars()

	src.gas.plasma = 0
	src.gas.oxygen = 0
	src.gas.n2 = 0
	src.gas.sl_gas = 0

	var/temp = src.gas.temperature
	spawn(10)
		T.firelevel = temp * 3600.0
		T.res_vars()



/obj/item/weapon/tank/plasmatank/proc/ignite()
	spawn(0)
		var/strength = ((src.gas.plasma + src.gas.oxygen/2.0) / 1600000.0) * src.gas.temperature
		//if ((src.gas.plasma < 1600000.0 || src.gas.temperature < 773))		//500degC
		if (strength < 773.0)
			var/turf/T = get_turf(src.loc)
			T.poison += src.gas.plasma
			T.firelevel = T.poison
			T.res_vars()

			if(src.master)
				src.master.loc = null

			//if ((src.gas.temperature > (450+T0C) && src.gas.plasma == 1600000.0))
			if (strength > (450+T0C))
				var/turf/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
				var/turf/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
				defer_powernet_rebuild = 1
				var/num = 0
				for(var/turf/U in shuffle(block(sw, ne)))
					var/zone = 4
					if ((U.y <= (T.y + 1) && U.y >= (T.y - 1) && U.x <= (T.x + 2) && U.x >= (T.x - 2)) )
						zone = 3
					if ((U.y <= (T.y + 1) && U.y >= (T.y - 1) && U.x <= (T.x + 1) && U.x >= (T.x - 1) ))
						zone = 2
					for(var/atom/A in U)
						if(A != src)
							A.ex_act(zone)
						//Foreach goto(342)
					U.ex_act(zone)
					U.buildlinks()
					num++;
					if(num>100)
						sleep(1)
						num = 0
					//Foreach goto(170)
				defer_powernet_rebuild = 0
				makepowernets()

			else
				//if ((src.gas.temperature > (300+T0C) && src.gas.plasma == 1600000.0))
				if (strength > (300+T0C))
					var/turf/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
					var/turf/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
					defer_powernet_rebuild = 1

					var/num = 0
					for(var/turf/U in shuffle(block(sw, ne)))
						var/zone = 4
						if ((U.y <= (T.y + 2) && U.y >= (T.y - 2) && U.x <= (T.x + 2) && U.x >= (T.x - 2)) )
							zone = 3
						for(var/atom/A in U)
							if(A != src)
								A.ex_act(zone)
							//Foreach goto(598)
						U.ex_act(zone)
						U.buildlinks()
						num++;
						if(num>100)
							sleep(1)
							num = 0
						//Foreach goto(498)
					defer_powernet_rebuild = 0
					makepowernets()

			//src.master = null
			del(src.master)
			//SN src = null
			del(src)
			return

		var/turf/T = src.loc
		while(!( istype(T, /turf) ))
			T = T.loc

		if(src.master)
			src.master.loc = null

		for(var/mob/M in range(T))
			flick("flash", M.flash)
			//Foreach goto(732)
		//var/m_range = 2
		var/m_range = round(strength / 387)
		for(var/obj/machinery/atmoalter/canister/C in range(2, T))
			if (!( C.destroyed ))
				if (C.gas.plasma >= 35000)
					C.destroyed = 1
					m_range++
			//Foreach goto(776)
		var/min = m_range
		var/med = m_range * 2
		var/max = m_range * 3
		var/u_max = m_range * 4

		var/turf/sw = locate(max(T.x - u_max, 1), max(T.y - u_max, 1), T.z)
		var/turf/ne = locate(min(T.x + u_max, world.maxx), min(T.y + u_max, world.maxy), T.z)

		defer_powernet_rebuild = 1

		var/num = 0
		for(var/turf/U in shuffle(block(sw, ne)))


			var/zone = 4
			if ((U.y <= (T.y + max) && U.y >= (T.y - max) && U.x <= (T.x + max) && U.x >= (T.x - max) ))
				zone = 3
			if ((U.y <= (T.y + med) && U.y >= (T.y - med) && U.x <= (T.x + med) && U.x >= (T.x - med) ))
				zone = 2
			if ((U.y <= (T.y + min) && U.y >= (T.y - min) && U.x <= (T.x + min) && U.x >= (T.x - min) ))
				zone = 1
			for(var/atom/A in U)
				if(A != src)
					A.ex_act(zone)
				//Foreach goto(1217)
			U.ex_act(zone)
			U.buildlinks()
			num++;
			if(num>100)
				sleep(1)
				num = 0
			//U.mark(zone)

			//Foreach goto(961)
		//src.master = null
		defer_powernet_rebuild = 0
		makepowernets()

		del(src.master)
		//SN src = null
		del(src)
		return

/obj/item/weapon/tank/plasmatank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/assembly/rad_ignite))
		var/obj/item/weapon/assembly/rad_ignite/S = W
		if (!( S.status ))
			return
		var/obj/item/weapon/assembly/r_i_ptank/R = new /obj/item/weapon/assembly/r_i_ptank( user )
		R.part1 = S.part1
		S.part1.loc = R
		S.part1.master = R
		R.part2 = S.part2
		S.part2.loc = R
		S.part2.master = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part3 = src
		R.layer = 52
		R.loc = user
		S.part1 = null
		S.part2 = null
		//S = null
		del(S)
	if (istype(W, /obj/item/weapon/assembly/prox_ignite))
		var/obj/item/weapon/assembly/prox_ignite/S = W
		if (!( S.status ))
			return
		var/obj/item/weapon/assembly/m_i_ptank/R = new /obj/item/weapon/assembly/m_i_ptank( user )
		R.part1 = S.part1
		S.part1.loc = R
		S.part1.master = R
		R.part2 = S.part2
		S.part2.loc = R
		S.part2.master = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part3 = src
		R.layer = 52
		R.loc = user
		S.part1 = null
		S.part2 = null
		//S = null
		del(S)

	if (istype(W, /obj/item/weapon/assembly/time_ignite))
		var/obj/item/weapon/assembly/time_ignite/S = W
		if (!( S.status ))
			return
		var/obj/item/weapon/assembly/t_i_ptank/R = new /obj/item/weapon/assembly/t_i_ptank( user )
		R.part1 = S.part1
		S.part1.loc = R
		S.part1.master = R
		R.part2 = S.part2
		S.part2.loc = R
		S.part2.master = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part3 = src
		R.layer = 52
		R.loc = user
		S.part1 = null
		S.part2 = null
		//S = null
		del(S)
	if (istype(W, /obj/item/weapon/assembly/a_i_a))
		var/obj/item/weapon/assembly/a_i_a/S = W
		if (!( S.status ))
			return
		var/obj/item/weapon/clothing/suit/a_i_a_ptank/R = new /obj/item/weapon/clothing/suit/a_i_a_ptank( user )
		R.part1 = S.part1
		S.part1.loc = R
		S.part1.master = R
		R.part2 = S.part2
		S.part2.loc = R
		S.part2.master = R
		R.part3 = S.part3
		S.part3.loc = R
		S.part3.master = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part4 = src
		R.layer = 52
		R.loc = user
		S.part1 = null
		S.part2 = null
		S.part3 = null
		//S = null
		del(S)
	return

/obj/item/weapon/tank/plasmatank/New()
	..()
	src.gas.plasma = src.maximum
	return

/obj/secloset/alter_health()
	var/turf/T = get_turf(src)	//don't ask why we alter temperature in here. fuck this build
	return T

/obj/secloset/CheckPass(O as mob|obj, target as turf)
	if(ismob(O))
		var/mob/m = O
		if(m.noclip)
			return 1
	if (!( src.opened ))
		return 0
	else
		return 1
	return

/obj/secloset/personal/var/registered = null
/obj/secloset/personal/req_access = list(access_all_personal_lockers)

/obj/secloset/personal/New()
	..()
	sleep(2)
	new /obj/item/weapon/radio/signaler( src )
	new /obj/item/weapon/pen( src )
	new /obj/item/weapon/storage/backpack( src )
	new /obj/item/weapon/radio/headset( src )
	return

/obj/secloset/personal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W) W.loc = src.loc
	else if (istype(W, /obj/item/weapon/card/id))
		if(src.broken)
			user << "\red It appears to be broken."
			return
		var/obj/item/weapon/card/id/I = W
		if (src.allowed(user) || !src.registered || (istype(W, /obj/item/weapon/card/id) && src.registered == I.registered))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )
			for(var/mob/O in viewers(user, 3))
				if ((O.client && !( O.blinded )))
					O << text("\blue The locker has been []locked by [].", (src.locked ? null : "un"), user)
			src.icon_state = text("[]secloset0", (src.locked ? "1" : null))
			if (!src.registered)
				src.registered = I.registered
				src.desc = "Owned by [I.registered]."
		else
			user << "\red Access Denied"
	else if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
		src.broken = 1
		src.locked = 0
		src.desc = "It appears to be broken."
		src.icon = 'secloset_broken.dmi'
		src.icon_state = "secloset0"
		for(var/mob/O in viewers(user, 3))
			if ((O.client && !( O.blinded )))
				O << text("\blue The locker has been broken by [user] with an electromagnetic card!")
	else
		user << "\red Access Denied"
	return

/obj/secloset/security2/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/lglo_kit( src )
	new /obj/item/weapon/storage/lglo_kit( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/f_print_scanner( src )
	new /obj/item/weapon/f_print_scanner( src )
	new /obj/item/weapon/f_print_scanner( src )
	return

/obj/secloset/security1/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/gun/energy/taser_gun(src)
	new /obj/item/weapon/flash(src)
	new /obj/item/weapon/clothing/under/red(src)
	new /obj/item/weapon/clothing/shoes/brown(src)
	new /obj/item/weapon/clothing/suit/armor(src)
	new /obj/item/weapon/clothing/head/helmet(src)
	new /obj/item/weapon/clothing/glasses/sunglasses(src)
	new /obj/item/weapon/baton(src)
	return

/obj/secloset/highsec/New()
	..()
	sleep(2)
	new /obj/item/weapon/gun/energy/laser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/flash( src )
	new /obj/item/weapon/storage/id_kit( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/glasses/sunglasses( src )
	new /obj/item/weapon/clothing/suit/armor( src )
	new /obj/item/weapon/clothing/head/helmet( src )
	return

/obj/secloset/captains/New()
	..()
	sleep(2)
	new /obj/item/weapon/gun/energy/laser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/storage/id_kit( src )
	new /obj/item/weapon/clothing/under/darkgreen( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/glasses/sunglasses( src )
	new /obj/item/weapon/clothing/suit/armor( src )
	new /obj/item/weapon/clothing/head/helmet/swat_hel( src )
	return

/obj/secloset/animal/New()
	..()
	sleep(2)
	new /obj/item/weapon/radio/signaler( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	return

/obj/secloset/medical1/New()
	..()
	sleep(2)
	new /obj/item/weapon/bottle/toxins( src )
	new /obj/item/weapon/bottle/rejuvenators( src )
	new /obj/item/weapon/bottle/s_tox( src )
	new /obj/item/weapon/bottle/s_tox( src )
	new /obj/item/weapon/bottle/toxins( src )
	new /obj/item/weapon/bottle/r_epil( src )
	new /obj/item/weapon/bottle/r_ch_cough( src )
	new /obj/item/weapon/pill_canister/Tourette( src )
	new /obj/item/weapon/pill_canister/Fever( src )
	new /obj/item/weapon/pill_canister/cough( src )
	new /obj/item/weapon/pill_canister/epilepsy( src )
	new /obj/item/weapon/pill_canister/sleep( src )
	new /obj/item/weapon/pill_canister/antitoxin( src )
	new /obj/item/weapon/pill_canister/placebo( src )
	new /obj/item/weapon/storage/firstaid/syringes( src )
	new /obj/item/weapon/storage/gl_kit( src )
	new /obj/item/weapon/dropper( src )
	new /obj/item/weapon/cane( src )
	new /obj/item/weapon/cane( src )
	new /obj/item/weapon/cane( src )
	return

/obj/secloset/medical2/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	return

/obj/secloset/toxin/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/oxygentank( src )
	new /obj/item/weapon/clothing/mask/gasmask( src )
	new /obj/item/weapon/clothing/suit/bio_suit( src )
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/gloves/latex( src )
	new /obj/item/weapon/clothing/head/bio_hood( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)
	return


/obj/secloset/bar/New()
	..()
	sleep(2)
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	new /obj/item/weapon/drink/beer( src )
	return
/obj/secloset/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		else
	return

/obj/secloset/blob_act()
	if (prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/secloset/meteorhit(obj/O as obj)
	if (O.icon_state == "flaming")
		for(var/obj/item/I in src)
			I.loc = src.loc
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		src.icon_state = "secloset1"
		del(src)
		return
	return

/obj/secloset/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)	//act like they were dragged onto the closet
		user.drop_item()
		if (W)
			W.loc = src.loc
	else if(src.broken)
		user << "\red It appears to be broken."
		return
	else if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
		src.broken = 1
		src.locked = 0
		src.icon = 'secloset_broken.dmi'
		src.icon_state = "secloset0"
		for(var/mob/O in viewers(user, 3))
			if ((O.client && !( O.blinded )))
				O << text("\blue The locker has been broken by [user] with an electromagnetic card!")
	else if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if ((O.client && !( O.blinded )))
				O << text("\blue The locker has been []locked by [].", (src.locked ? null : "un"), user)
		src.icon_state = text("[]secloset0", (src.locked ? "1" : null))
	else
		user << "\red Access Denied"
	return

/obj/secloset/relaymove(mob/user as mob)
	if (user.stat)
		return
	if (!( src.locked ))
		for(var/obj/item/I in src)
			I.loc = src.loc
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		src.icon_state = "secloset1"
		src.opened = 1
	else
		user << "\blue It's welded shut!"
		user.unlock_medal("IT'S A TRAP", 1, "Get trapped inside of a welded locker.", "easy")
		for(var/mob/M in hearers(src, null))
			M << text("<FONT size=[]>BANG, bang!</FONT>", max(0, 5 - get_dist(src, M)))
	return

/obj/secloset/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((user.restrained() || user.stat))
		return
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if(!src.opened)
		return
	step_towards(O, src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				B << text("\red [] stuffs [] into []!", user, O, src)
	src.add_fingerprint(user)
	return

/obj/secloset/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if (!src.opened && !src.locked)
		//open it
		for(var/obj/item/I in src)
			I.loc = src.loc
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		src.icon_state = "secloset1"
		src.opened = 1
	else if(src.opened)
		//close it
		for(var/obj/item/I in src.loc)
			if (!( I.anchored ))
				I.loc = src
		for(var/mob/M in src.loc)
			if (M.buckled)
				continue
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
		src.icon_state = "secloset0"
		src.opened = 0
	else
		return src.attackby(null, user)
	return

/obj/secloset/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/morgue/proc/update()
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
		else
			src.icon_state = "morgue1"
	return

/obj/morgue/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
	return

/obj/morgue/alter_health()
	return src.loc

/obj/morgue/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.loc = src
		//src.connected = null
		del(src.connected)
	else
		src.connected = new /obj/m_tray( src.loc )
		step(src.connected, EAST)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, EAST)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "morgue0"
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.connected.loc
			src.connected.icon_state = "morguet"
		else
			//src.connected = null
			del(src.connected)
	src.add_fingerprint(user)
	update()
	return

/obj/morgue/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.equipped() != P)
			return
		if ((get_dist(src, usr) > 1 && src.loc != user))
			return
		t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
		if (t)
			src.name = text("Morgue- '[]'", t)
		else
			src.name = "Morgue"
	src.add_fingerprint(user)
	return

/obj/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.connected = new /obj/m_tray( src.loc )
	step(src.connected, EAST)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.connected.loc
			//Foreach goto(106)
		src.connected.icon_state = "morguet"
	else
		//src.connected = null
		del(src.connected)
	return

/obj/m_tray/CheckPass(D as obj)
	if (istype(D, /obj/item/weapon/dummy))
		return 1
	else
		return ..()
	return

/obj/m_tray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.loc = src.connected
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		del(src)
		return
	return

/obj/m_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	O.loc = src.loc
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				B << text("\red [] stuffs [] into []!", user, O, src)
			//Foreach goto(99)
	return

/obj/closet/alter_health()
	return src.loc

/obj/closet/CheckPass(O as mob|obj, target as turf)
	if(ismob(O))
		var/mob/m = O
		if(m.noclip)
			return 1
	if(!src.opened)
		return 0
	else
		return 1
	return

/obj/cabinet/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/folder( src )
	new /obj/item/weapon/storage/folder( src )
	new /obj/item/weapon/storage/folder( src )

/obj/closet/cabinet/New()  //Delete this when real cabinets work - Trorbes 01/01/2010
	..()
	sleep(2)
	new /obj/item/weapon/storage/folder( src )
	new /obj/item/weapon/storage/folder( src )
	new /obj/item/weapon/storage/folder( src )

/obj/item/weapon/storage/folder/New()

	new /obj/item/weapon/paper( src )
	new /obj/item/weapon/paper( src )
	new /obj/item/weapon/paper( src )
	..()
	return

/obj/closet/syndicate/nuclear/New()
	..()
	sleep(2)
	new /obj/item/weapon/ammo/a357( src )
	new /obj/item/weapon/ammo/a357( src )
	new /obj/item/weapon/ammo/a357( src )
	new /obj/item/weapon/storage/handcuff_kit( src )
	new /obj/item/weapon/storage/flashbang_kit( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/pinpointer( src )
	new /obj/item/weapon/pinpointer( src )
	new /obj/item/weapon/pinpointer( src )
	var/obj/item/weapon/syndicate_uplink/U = new /obj/item/weapon/syndicate_uplink( src )
	U.uses = 15
	return

/obj/closet/syndicate/personal/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/jetpack(src)
	new /obj/item/weapon/clothing/mask/m_mask(src)
	new /obj/item/weapon/clothing/head/s_helmet/syndicate(src)
	new /obj/item/weapon/clothing/suit/sp_suit/syndicate(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/cell(src)
	new /obj/item/weapon/card/id/syndicate(src)
	new /obj/item/weapon/multitool(src)

/obj/closet/thunderdome/New()
	..()
	sleep(2)

/obj/closet/thunderdome/tdred/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/suit/swat_suit/tdred(src)
	new /obj/item/weapon/clothing/suit/swat_suit/tdred(src)
	new /obj/item/weapon/clothing/suit/swat_suit/tdred(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)

/obj/closet/thunderdome/tdgreen/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/suit/swat_suit/tdgreen(src)
	new /obj/item/weapon/clothing/suit/swat_suit/tdgreen(src)
	new /obj/item/weapon/clothing/suit/swat_suit/tdgreen(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/sword(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/gun/energy/laser_gun(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)
	new /obj/item/weapon/clothing/head/helmet/tdhelm(src)

/obj/closet/malf/suits/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/jetpack(src)
	new /obj/item/weapon/clothing/mask/m_mask(src)
	new /obj/item/weapon/clothing/head/s_helmet/syndicate(src)
	new /obj/item/weapon/clothing/suit/sp_suit/syndicate(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/cell(src)
	new /obj/item/weapon/multitool(src)

/obj/closet/gmcloset/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/head/that(src)
	new /obj/item/weapon/clothing/head/that(src)
	new /obj/item/weapon/clothing/under/sl_suit(src)
	new /obj/item/weapon/clothing/under/sl_suit(src)
	new /obj/item/weapon/clothing/under/bartender(src)
	new /obj/item/weapon/clothing/under/bartender(src)
	new /obj/item/weapon/clothing/suit/wcoat(src)
	new /obj/item/weapon/clothing/suit/wcoat(src)
	new /obj/item/weapon/clothing/shoes/black(src)
	new /obj/item/weapon/clothing/shoes/black(src)

/obj/closet/jcloset/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/suit/bio_suit(src)
	new /obj/item/weapon/clothing/head/bio_hood(src)
	new /obj/item/weapon/clothing/under/janitor(src)
	new /obj/item/weapon/clothing/under/janitor(src)
	new /obj/item/weapon/clothing/shoes/black(src)
	new /obj/item/weapon/clothing/shoes/black(src)
	new /obj/item/weapon/flashlight(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)

/obj/closet/emcloset/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/oxygentank( src )
	new /obj/item/weapon/clothing/mask/gasmask( src )
	return

/obj/closet/l3closet/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/suit/bio_suit( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/head/bio_hood( src )

	return

/obj/closet/wardrobe/New()
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/red/New()
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return
/obj/closet/wardrobe/forensics_red/New()
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/under/forensics_red( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return
/obj/closet/wardrobe/firefighter_red/New()
	new /obj/item/weapon/clothing/head/helmet/fire_hel(src)
	new /obj/item/weapon/clothing/under/firefighter_red( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/pink/New()
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return

/obj/closet/wardrobe/black/New()
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/under/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return
/obj/closet/wardrobe/chaplain_black/New()
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/under/chaplain_black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/green/New()
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/under/green( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/network/New()
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/under/network( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/orange/New()
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/under/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	return

/obj/closet/wardrobe/yellow/New()
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/under/yellow( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	return
/obj/closet/wardrobe/atmospherics_yellow/New()
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/under/atmospherics_yellow( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return
/obj/closet/wardrobe/engineering_yellow/New()
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/under/engineering_yellow( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	new /obj/item/weapon/clothing/shoes/orange( src )
	return

/obj/closet/wardrobe/white/New()
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/under/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/storage/stma_kit( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	return
/obj/closet/wardrobe/toxins_white/New()
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/under/toxins_white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/storage/stma_kit( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	return
/obj/closet/wardrobe/genetics_white/New()
	new /obj/item/weapon/clothing/under/genetics_white( src )
	new /obj/item/weapon/clothing/under/genetics_white( src )
	new /obj/item/weapon/clothing/under/genetics_white( src )
	new /obj/item/weapon/clothing/under/genetics_white( src )
	new /obj/item/weapon/clothing/under/genetics_white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/storage/stma_kit( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	new /obj/item/weapon/clothing/suit/labcoat(src)
	return
/obj/closet/wardrobe/grey/New()
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/under/grey( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	new /obj/item/weapon/clothing/shoes/black( src )
	return

/obj/closet/wardrobe/mixed/New()
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/blue( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/under/pink( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	return
/obj/secloset/chemtoxin/New()
	new /obj/item/weapon/bottle/antitoxins( src )
	new /obj/item/weapon/bottle/r_ch_cough( src )
	new /obj/item/weapon/bottle/r_epil ( src )
	new /obj/item/weapon/bottle/r_fever ( src )
	new /obj/item/weapon/bottle/rejuvenators( src )
	new /obj/item/weapon/bottle/s_tox( src )
	new /obj/item/weapon/bottle/toxins ( src )
	return

/obj/closet/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		else
	return


/obj/secloset/blob_act()
	if (prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/closet/meteorhit(obj/O as obj)
	if (O.icon_state == "flaming")
		for(var/obj/item/I in src)
			I.loc = src.loc
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		src.icon_state = src.icon_opened
		del(src)
		return
	return

/obj/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if (!user.can_use_hands())
		return
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if (user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if (!istype(user.loc, /turf)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	step_towards(O, src.loc)
	user.show_viewers(text("\red [] stuffs [] into []!", user, O, src))
	src.add_fingerprint(user)
	return

/obj/closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W)
			W.loc = src.loc
	else if(istype(W, /obj/item/weapon/weldingtool) && W:welding)
		if (W:weldfuel < 2)
			user << "\blue You need more welding fuel to complete this task."
			return
		W:weldfuel -= 2
		src.welded =! src.welded
		for(var/mob/M in viewers(src))
			M.show_message("\red [src] has been [welded?"welded shut":"unwelded"] by [user.name].", 3, "\red You hear welding.", 2)
	else
		src.attack_hand(user)
	return

/obj/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if (!src.opened)
		if (!src.welded)
			for(var/obj/item/I in src)
				I.loc = src.loc
			for(var/mob/M in src)
				M.loc = src.loc
				if (M.client)
					M.client.eye = M.client.mob
					M.client.perspective = MOB_PERSPECTIVE
			src.icon_state = src.icon_opened
			src.opened = 1
		else
			usr << "\blue It's welded shut!"
	else
		for(var/obj/item/I in src.loc)
			if (!( I.anchored ))
				I.loc = src
		for(var/mob/M in src.loc)
			if (M.buckled)
				continue
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
		src.icon_state = src.icon_closed
		src.opened = 0
	return

/obj/closet/relaymove(mob/user as mob)

	if (user.stat)
		return
	if (!( src.welded ))
		for(var/obj/item/I in src)
			I.loc = src.loc
		for(var/mob/M in src)
			M.loc = src.loc
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		src.icon_state = src.icon_opened
		src.opened = 1
	else
		user << "\blue It's welded shut!"
		for(var/mob/M in hearers(src, null))
			M << text("<FONT size=[]>BANG, bang!</FONT>", max(0, 5 - get_dist(src, M)))
	return

/obj/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)

	if ((user.restrained() || user.stat))
		return
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if (user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if (!istype(user.loc, /turf)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	step_towards(O, src.loc)
	for(var/mob/M in viewers(user, null))
		if ((M.client && !( M.blinded )))
			M << text("\red [] stuffs [] into []!", user, O, src)
	src.add_fingerprint(user)
	return

/obj/closet/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if (!src.opened)
		if (!src.welded)
			for(var/obj/item/I in src)
				I.loc = src.loc
			for(var/mob/M in src)
				if (!( M.buckled ))
					M.loc = src.loc
					if (M.client)
						M.client.eye = M.client.mob
						M.client.perspective = MOB_PERSPECTIVE
			src.icon_state = src.icon_opened
			src.opened = 1
		else
			usr << "\blue It's welded shut!"
	else
		for(var/obj/item/I in src.loc)
			if (!I.anchored)
				I.loc = src
		for(var/mob/M in src.loc)
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
		src.icon_state = src.icon_closed
		src.opened = 0
	return

/obj/closet/CheckPass(O as mob|obj, target as turf)
	if(ismob(O))
		var/mob/m = O
		if(m.noclip)
			return 1

	if (!( src.opened ))
		return 0
	else
		return 1
	return

/obj/stool/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(5))
				//SN src = null
				del(src)
				return
		else
	return

/obj/stool/blob_act()
	if(prob(50))
		new /obj/item/weapon/sheet/metal( src.loc )
		del(src)

/obj/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		//SN src = null
		del(src)
	return


/obj/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		return src.Del()
	return

/obj/stool/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/assembly/shock_kit))
		var/obj/stool/chair/e_chair/E = new /obj/stool/chair/e_chair( src.loc )
		E.dir = src.dir
		E.part1 = W
		W.loc = E
		W.master = E
		user.u_equip(W)
		W.layer = initial(W.layer)
		//SN src = null
		del(src)
		return
	return

/obj/stool/bed/Del()
	for(var/mob/M in src.loc)
		if (M.buckled == src)
			M.buckled = null
			M.lying = 0
			M.anchored = 0
	..()
	return

/obj/stool/bed/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
		return
	if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M == usr)
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] buckles in!", M)
	else
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] is buckled in by [].", M, user)
	M.lying = 1
	M.anchored = 1
	M.buckled = src
	M.loc = src.loc
	src.add_fingerprint(user)
	return

/obj/stool/bed/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] is unbuckled by [].", M, user)
			else
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] unbuckles.", M)
//			world << "[M] is no longer buckled to [src]"
			M.anchored = 0
			M.buckled = null
			src.add_fingerprint(user)
	return

/obj/stool/chair/e_chair/New()

	src.overl = new /atom/movable/overlay( src.loc )
	src.overl.icon = 'Icons.dmi'
	src.overl.icon_state = "e_chairo0"
	src.overl.layer = 5
	src.overl.name = "electrified chair"
	src.overl.master = src
	return

/obj/stool/chair/e_chair/Del()

	//src.overl = null
	del(src.overl)
	..()
	return

/obj/stool/chair/e_chair/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		var/obj/stool/chair/C = new /obj/stool/chair( src.loc )
		C.dir = src.dir
		src.part1.loc = src.loc
		src.part1.master = null
		src.part1 = null
		//SN src = null
		del(src)
		return
	return

/obj/stool/chair/e_chair/verb/toggle_power()
	set src in oview(1)

	if ((usr.stat || usr.restrained() || !( usr.canmove ) || usr.lying))
		return
	src.on = !( src.on )
	src.icon_state = text("e_chair[]", src.on)
	src.overl.icon_state = text("e_chairo[]", src.on)
	return

/obj/stool/chair/e_chair/proc/shock()
	if (!( src.on ))
		return
	if ( (src.last_time + 50) > world.time)
		return
	src.last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(EQUIP))
		return
	A.use_power(EQUIP, 5000)
	var/light = A.power_light
	A.updateicon()

	flick("e_chairs", src)
	flick("e_chairos", src.overl)
	for(var/mob/M in src.loc)
		M.burn_skin(85)
		M << "\red <B>You feel a deep shock course through your body!</B>"
		sleep(1)
		M.burn_skin(85)
		if(M.stunned < 600)	M.stunned = 600
	for(var/mob/M in hearers(src, null))
		M.show_message("\red The electric chair went off!.", 3, "\red You hear a deep sharp shock.", 2)

	A.power_light = light
	A.updateicon()
	return

/obj/stool/chair/ex_act(severity)
	for(var/mob/M in src.loc)
		if(M.buckled == src)
			M.buckled = null
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
	return

/obj/stool/chair/blob_act()
	if(prob(50))
		for(var/mob/M in src.loc)
			if(M.buckled == src)
				M.buckled = null
		del(src)

/obj/stool/chair/New()
	src.verbs -= /atom/movable/verb/pull
	if (src.dir == NORTH)
		src.layer = FLY_LAYER
	..()
	return

/obj/stool/chair/Del()
	for(var/mob/M in src.loc)
		if (M.buckled == src)
			M.buckled = null
	..()
	return

/obj/stool/chair/verb/rotate()
	set src in oview(1)

	src.dir = turn(src.dir, 90)
	if (src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	return

/obj/stool/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
		return
	if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M == usr)
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] buckles in!", user)
	else
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] is buckled in by []!", M, user)
	M.anchored = 1
	M.buckled = src
	M.loc = src.loc
	src.add_fingerprint(user)
	return

/obj/stool/chair/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/stool/chair/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] is unbuckled by [].", M, user)
			else
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] unbuckles.", M)
//			world << "[M] is no longer buckled to [src]"
			M.anchored = 0
			M.buckled = null
			src.add_fingerprint(user)
	return

/obj/grille/New()
	..()

//returns the netnum of a stub cable at this grille loc, or 0 if none

/obj/grille/proc/get_connection()
	var/turf/T = src.loc
	if(!istype(T, /turf/station/floor))
		return

	for(var/obj/cable/C in T)
		if(C.d1 == 0)
			return C.netnum

	return 0


/obj/grille/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.health -= 11
				healthcheck()
		else
	return

/obj/grille/blob_act()
	src.health--
	src.healthcheck()


/obj/grille/meteorhit(var/obj/M)
	if (M.icon_state == "flaming")
		src.health -= 2
		healthcheck()
	return

/obj/grille/attack_hand(var/obj/M)
	var/QQ = rand(1,6)
	src.hear_sound("sound/damage/wall/impact[QQ].wav",6)
	usr << text("\blue You kick the grille.")
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << text("\red [] kicks the grille.", usr)
	src.health -= 2
	healthcheck()
	return

/obj/grille/attack_paw(var/obj/M)
	var/QQ = rand(1,6)
	src.hear_sound("sound/damage/wall/impact[QQ].wav",6)
	usr << text("\blue You kick the grille.")
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << text("\red [] kicks the grille.", usr)
	src.health -= 2
	healthcheck()
	return

/obj/grille/CheckPass(var/obj/B)
	if ((istype(B, /obj/effects) || istype(B, /obj/item/weapon/dummy) || istype(B, /obj/beam) || istype(B, /obj/meteor/small)))
		return 1
	else
		if(ismob(B))
			var/mob/m = B
			if(m.noclip)
				return 1
		if (istype(B, /obj/bullet))
			return prob(30)
		else
			return !( src.density )
	return

/obj/grille/attackby(obj/item/weapon/W, mob/user)
	if (istype(W, /obj/item/weapon/wirecutters))
		if(!shock(user, 100))
			src.health = 0
	else if ((istype(W, /obj/item/weapon/screwdriver) && (istype(src.loc, /turf/station) || src.anchored)))
		if(!shock(user, 90))
			src.anchored = !( src.anchored )
			user << (src.anchored ? "You have fastened the grille to the floor." : "You have unfastened the grill.")
	else if(istype(W, /obj/item/weapon/shard))	// can't get a shock by attacking with glass shard
		src.health -= W.force * 0.1

	else						// anything else, chance of a shock
		if(!shock(user, 70))
			switch(W.damtype)
				if("fire")
					src.health -= W.force
				if("brute")
					src.health -= W.force * 0.1

	src.healthcheck()
	..()
	return

/obj/grille/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.icon_state = "brokengrille"
			src.density = 0
			src.destroyed = 1
			new /obj/item/weapon/rods( src.loc )

		else
			if (src.health <= -10.0)
				new /obj/item/weapon/rods( src.loc )
				//SN src = null
				del(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/grille/proc/shock(mob/user, prb)

	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0

	if(!prob(prb))
		return 0

	var/net = get_connection()		// find the powernet of the connected cable

	if(!net)		// cable is unpowered
		return 0

	return src.electrocute(user, prb, net)

/obj/window/las_act(flag)
	var/B = pick(1,2,3,4)
	src.hear_sound("sound/damage/glass/impact[B].wav",6)
	if (flag == "bullet")
		if(!reinf)
			new /obj/item/weapon/shard( src.loc )
			//SN src = null
			src.density = 0
			src.loc.buildlinks()

			del(src)
		else
			health -= 35
			if(health <=0)
				new /obj/item/weapon/shard( src.loc )
				new /obj/item/weapon/rods( src.loc )
				src.density = 0
				src.loc.buildlinks()
				del(src)

		return
	return

/obj/window/ex_act(severity)
	var/B = pick(1,2,3,4)
	src.hear_sound("sound/damage/glass/impact[B].wav",6)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/weapon/rods( src.loc)
			//SN src = null
			del(src)
			return
		if(3.0)
			if (prob(50))
				new /obj/item/weapon/shard( src.loc )
				if(reinf) new /obj/item/weapon/rods( src.loc)

				del(src)
				return
	return

/obj/window/blob_act()
	if(prob(50))
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/weapon/rods( src.loc)
		density = 0
		src.loc.buildlinks()
		del(src)

/obj/window/CheckPass(atom/movable/O as mob|obj, target as turf)
	if(ismob(O))
		var/mob/m = O
		if(m.noclip)
			return 1
	if (istype(O, /obj/beam))
		return 1
	if (src.dir == SOUTHWEST)
		return 0
	else
		if (get_dir(target, O.loc) == src.dir)
			return 0
	return 1

/obj/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if (get_dir(O.loc, target) == src.dir)
		return 0
	return 1

/obj/window/meteorhit()
	var/B = pick(1,2,3,4)
	src.hear_sound("sound/damage/glass/impact[B].wav",6)

	//*****RM
	//world << "glass at [x],[y],[z] Mhit"
	src.health = 0
	new /obj/item/weapon/shard( src.loc )
	if(reinf) new /obj/item/weapon/rods( src.loc)
	src.density = 0
	src.loc.buildlinks()


	del(src)
	return


/obj/window/hitby(obj/item/weapon/W as obj)
	var/B = pick(1,2,3,4)
	src.hear_sound("sound/damage/glass/impact[B].wav",6)

	..()
	var/tforce = W.throwforce
	if(reinf) tforce /= 4.0

	src.health = max(0, src.health - tforce)
	if (src.health <= 7 && !reinf)
		src.anchored = 0
		step(src, get_dir(W, src))
	if (src.health <= 0)
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/weapon/rods( src.loc)
		src.density = 0
		src.loc.buildlinks()
		del(src)
		return
	..()
	return

/obj/window/attack_hand()

	if (usr.ishulk)
		var/B = pick(1,2,3,4)
		src.hear_sound("sound/damage/glass/impact[B].wav",6)
		usr << text("\blue You smash through the window.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes through the window.", usr)
		src.health = 0
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/weapon/rods( src.loc)
		src.density = 0
		src.loc.buildlinks()
		del(src)
	if ((usr.zombie && prob(10)) || (usr.is_rev=="no"&&prob(30)))
		var/B = pick(1,2,3,4)
		src.hear_sound("sound/damage/glass/impact[B].wav",6)
		usr << text("\blue You smash through the window.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes through the window.", usr)
		src.health = 0
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/weapon/rods( src.loc)
		src.density = 0
		src.loc.buildlinks()
		del(src)
	return

/obj/window/attack_paw()
	if (usr.ishulk)
		var/B = pick(1,2,3,4)
		src.hear_sound("sound/damage/glass/impact[B].wav",6)
		usr << text("\blue You smash through the window.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes through the window.", usr)
		src.health = 0
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/weapon/rods( src.loc)
		src.density = 0
		src.loc.buildlinks()
		del(src)
	return

/obj/window/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/chem/beaker))
		var/obj/item/weapon/chem/beaker/V = W
		if (V:chem.chemicals.Find("silicate") && V:chem.chemicals.len == 1)
			var/obj/substance/chemical/S = V:chem.split(10)
			if (S.volume() >= 10)
				src.icon += rgb(60,0,-40)
				src.health *= 2
				user << "\blue You apply the silicate to the window."
			else
				user << "\blue You don't have enough silicate to cover the window, and toss your beaker away in disgust!"
				del (W)
			if (S)
				del (S)
			return
		if (V:chem.chemicals.Find("acid") && V:chem.chemicals.len == 1)
			var/obj/substance/chemical/S = V:chem.split(10)
			if (S.volume() >= 10)
				user << "\blue You splash acid on the window!"
				src.health = 0
				new /obj/item/weapon/shard( src.loc )
				if(reinf) new /obj/item/weapon/rods( src.loc)
				src.density = 0
				src.loc.buildlinks()
				del(src)
			else
				user << "\blue You throw your beaker at the window, but there isn't enough acid inside to melt it!"
				del (W)
				if (S)
					del (S)
			return
	if (istype(W, /obj/item/weapon/screwdriver))
		if(reinf && state >= 1)
			state = 3 - state
			usr << ( state==1? "You have unfastened the window from the frame." : "You have fastened the window to the frame." )
		else if(reinf && state == 0)
			anchored = !anchored
			user << (src.anchored ? "You have fastened the frame to the floor." : "You have unfastened the frame from the floor.")
		else if(!reinf)
			src.anchored = !( src.anchored )
			user << (src.anchored ? "You have fastened the window to the floor." : "You have unfastened the window.")
	else if(istype(W, /obj/item/weapon/crowbar) && reinf)
		if(state <=1)
			state = 1-state;
			user << (state ? "You have pried the window into the frame." : "You have pried the window out of the frame.")
	else
		var/B = pick(1,2,3,4)
		src.hear_sound("sound/damage/glass/impact[B].wav",6)
		var/aforce = W.force
		if(reinf) aforce /= 2.0
		src.health = max(0, src.health - aforce)
		if (src.health <= 7)
			src.anchored = 0
			var/turf/sl = src.loc
			step(src, get_dir(user, src))
			sl.buildlinks()
			src.loc.buildlinks()
		if (src.health <= 0)
			if (src.dir == SOUTHWEST)
				var/index = null
				index = 0
				while(index < 2)
					new /obj/item/weapon/shard( src.loc )
					if(reinf) new /obj/item/weapon/rods( src.loc)
					index++
			else
				new /obj/item/weapon/shard( src.loc )
				if(reinf) new /obj/item/weapon/rods( src.loc)
			src.density = 0
			src.loc.buildlinks()
			del(src)
			return
		..()
	src.loc.buildlinks()
	return


/obj/window/verb/rotate()
	set src in oview(1)

	if (src.anchored)
		usr << "It is fastened to the floor; therefore, you can't rotate it!"
		return 0
	else
		if (src.dir == SOUTHWEST)
			usr << "You can't rotate this! "
			return 0
	src.dir = turn(src.dir, 90)
	src.ini_dir = src.dir
	src.loc.buildlinks()
	return

/obj/window/New(Loc,re=0)
	..()

	if(re)	reinf = re

	src.ini_dir = src.dir
	src.loc.buildlinks()
	if(reinf)
		icon_state = "rwindow"
		desc = "A reinforced window."
		name = "reinforced window"
		state = 2*anchored
		health = 40

	return

/obj/window/Del()
	src.density = 0
	src.loc.buildlinks()
	..()

/obj/window/Move()
	var/turf/sl = src.loc
	..()
	src.dir = src.ini_dir
	sl.buildlinks()
	src.loc.buildlinks()
	return

/atom/proc/meteorhit(obj/meteor as obj)
	return

/atom/proc/allow_drop()
	return 1

/atom/proc/CheckPass(atom/O as mob|obj|turf|area)
	if(istype(O,/atom/movable))
		var/atom/movable/A = O
		return (!src.density || (!A.density && !A.throwing))
	return (!O.density || !src.density)

/atom/proc/CheckExit()
	return 1

/atom/proc/HasEntered(atom/movable/AM as mob|obj)
	return

/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_paw(a, b, c)
	if (src.master)
		return src.master.attack_paw(a, b, c)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	return

/turf/CheckPass(atom/O as mob|obj|turf|area)
	if(ismob(O))
		var/mob/m = O
		if(m.noclip)
			return 1
	return !( src.density)

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return
	return

/turf/Enter(atom/movable/O as mob|obj, atom/forget as mob|obj|turf|area)

	if (!( isturf(O.loc) ))
		return 1
	for(var/atom/A in O.loc)
		if ((!( A.CheckExit(O, src) ) && O != A && A != forget))
			if (O)
				O.Bump(A, 1)
			return 0
	for(var/atom/A in src)
		if ((A.flags & 512 && get_dir(A, O) & A.dir))
			if ((!( A.CheckPass(O, src) ) && A != src && A != forget))
				if (O)
					O.Bump(A, 1)
				return 0
		if ((!( A.CheckPass(O, src) ) && A != forget))
			if (O)
				O.Bump(A, 1)
			return 0
	if (src != forget)
		if (!( src.CheckPass(O, src) ))
			if (O)
				O.Bump(src, 1)
			return 0
	return 1

/turf/Entered(atom/movable/M as mob|obj)
	if(ismob(M) && !istype(src, /turf/space))
		var/mob/tmob = M
		tmob.inertia_dir = 0
	..()
	for(var/atom/A as mob|obj|turf|area in src)
		spawn( 0 )
			if ((A && M))
				A.HasEntered(M, 1)
			return
	for(var/atom/A as mob|obj|turf|area in range(1))
		spawn( 0 )
			if ((A && M))
				A.HasProximity(M, 1)
			return
	return


/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)


/turf/station/r_wall/updatecell()

	if (src.state == 2)
		return
	else
		..()
	return

/turf/station/r_wall/proc/update()

	if (src.d_state == 7)
		src.d_state = 0
		src.state = 1
	if (src.state == 2)
		src.icon_state = text("r_wall[]", (src.d_state > 0 ? text("-[]", src.d_state) : null))
		src.opacity = 1
		src.density = 1
		src.updatecell = 0
		src.buildlinks()
	else
		src.icon_state = "r_girder"
		src.opacity = 0
		src.density = 1
		src.updatecell = 1
		src.buildlinks()
	return

/turf/station/r_wall/unburn()

	src.sd_SetLuminosity(0)
	src.update()
	return

/turf/station/r_wall/meteorhit(obj/M as obj)

	if ((M.icon_state == "flaming" && prob(30)))
		if (src.state == 2)
			src.state = 1
			new /obj/item/weapon/sheet/metal( src )
			new /obj/item/weapon/sheet/metal( src )
			update()
		else
			if ((prob(20) && src.state == 1))
				src.state = 0
				//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
				var/turf/station/floor/F = src.ReplaceWithFloor()
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				F.buildlinks()
				F.levelupdate()
	return

/turf/proc/ReplaceWithFloor()
	var/turf/station/floor/W
	var/area/A
	if (istype(src, /turf/space) || istype(src, /turf/station/wall) || istype(src, /turf/station/r_wall))
		var/area/oldArea = src:previousArea
		if (oldArea!=null)
			A = oldArea
		else
			A = src.loc
		W = new /turf/station/floor( locate(src.x, src.y, src.z) )
	else
		A = src.loc
		W = new /turf/station/floor( locate(src.x, src.y, src.z) )

	W.oxygen = src.oxygen

	W.poison = src.poison

	W.co2 = src.co2

	W.sl_gas = src.sl_gas

	W.n2 = src.n2

	W.temp = src.temp

	W.updatecell = 1

	if (istype(A, /area))
		if (A!=world.area)
			A.contents -= W
			A.contents += W
	return W

/turf/station/Entered(mob/human/M as mob, mob/user as mob)
	..();
	if(ismob(M))
	/*	if(src.radiation)
			if(M.has_air_contact())
				if(prob(50))
					if(M.radiation < 100)
						M.radiation += (src.radiation*0.01)*/
		if (src.wet == 1)
			if (M.m_intent == "run")
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
				M << "\blue You slipped on the wet floor!"
				M.stunned = 8
				M.weakened = 5
				if (prob(5))
					M << "... And also hit your head!"
					M.unlock_medal("Jack and Jill",1,"You hit your head on the ground after slipping on a wet floor.", "easy")
					M.stunned += 8
					M.weakened += 5
					M.bruteloss += 20
				if (src.chloro != 0)
					if (prob(chloro*10))
						M << "You inhale a strong whiff of an odor, coming from the floor."
						M.paralysis = max(M.paralysis,3)
			else
				M.inertia_dir = 0
			return

/turf/proc/ReplaceWithSpace()
	var oldAreaArea = src.loc
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	if (oldAreaArea==world.area)
		if (istype(src, /turf/station/wall) || istype(src, /turf/station/r_wall) || istype(src, /turf/space))
			S.previousArea = src:previousArea
		else
			S.previousArea = null
	else
		S.previousArea = oldAreaArea
	new /area( locate(src.x, src.y, src.z) )
	return S

/turf/proc/ReplaceWithWall()
	var oldAreaArea = src.loc
	var/turf/station/wall/S = new /turf/station/wall( locate(src.x, src.y, src.z) )

	S.oxygen = src.oxygen

	S.poison = src.poison

	S.co2 = src.co2

	S.sl_gas = src.sl_gas

	S.n2 = src.n2

	S.temp = src.temp
	if (oldAreaArea==world.area)
		if (istype(src, /turf/station/wall) || istype(src, /turf/station/r_wall) || istype(src, /turf/space))
			S.previousArea = src:previousArea
		else
			S.previousArea = null
	else
		S.previousArea = oldAreaArea
	new /area( locate(src.x, src.y, src.z) )
	return S

/turf/proc/ReplaceWithRWall()
	var oldAreaArea = src.loc
	var/turf/station/r_wall/S = new /turf/station/r_wall( locate(src.x, src.y, src.z) )
	S.oxygen = src.oxygen

	S.poison = src.poison

	S.co2 = src.co2

	S.sl_gas = src.sl_gas

	S.n2 = src.n2

	S.temp = src.temp
	if (oldAreaArea==world.area)
		if (istype(src, /turf/station/wall) || istype(src, /turf/station/r_wall) || istype(src, /turf/space))
			S.previousArea = src:previousArea
		else
			S.previousArea = null
	else
		S.previousArea = oldAreaArea
	new /area( locate(src.x, src.y, src.z) )
	return S

/turf/station/r_wall/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			var/turf/space/S = src.ReplaceWithSpace()
			S.buildlinks()

			//del(src)
			return
		if(2.0)
			if (prob(75))
				src.opacity = 0
				src.updatecell = 1
				src.buildlinks()
				src.state = 1
				src.intact = 0
				src.levelupdate()
				new /obj/item/weapon/sheet/metal( src )
				new /obj/item/weapon/sheet/metal( src )
			else
				src.state = 0
				//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
				var/turf/station/floor/F = src.ReplaceWithFloor()
				F.burnt = 1
				F.health = 30
				F.icon_state = "Floor1"
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				F.buildlinks()
				F.levelupdate()
		if(3.0)
			if (prob(15))
				src.opacity = 0
				src.updatecell = 1
				src.buildlinks()
				src.intact = 0
				src.levelupdate()
				src.state = 1
				new /obj/item/weapon/sheet/metal( src )
				new /obj/item/weapon/sheet/metal( src )
				src.icon_state = "girder"
				update()
		else
	return

/turf/station/r_wall/blob_act()

	if(prob(10))
		if(!intact)
			src.state = 0
			//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
			var/turf/station/floor/F = src.ReplaceWithFloor()
			F.burnt = 1
			F.health = 30
			F.icon_state = "Floor1"
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()
		else
			src.opacity = 0
			src.updatecell = 1
			src.buildlinks()
			src.state = 1
			src.intact = 0
			src.levelupdate()
			new /obj/item/weapon/sheet/metal( src )
			src.icon_state = "girder"
			update()



/turf/station/r_wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if (istype(W, /obj/item/weapon/chem/beaker))
		if (W:chem.chemicals.Find("thermite") && W:chem.chemicals.len == 1)
			var/obj/item/weapon/chem/beaker/V = W
			var/obj/substance/chemical/S = V:chem.split(20)
			if (S:volume() >= 20)
				var/turf/T = user.loc
				user << "\blue You carefully begin to affix the beaker to the wall."
				sleep (100)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					user << "\blue You affix the beaker to the wall."
					src.d_state = 8
					del (V)
					if (W)
						del (W)
				return
			else
				user <<"\blue You don't have enough thermite!"
	if (src.state == 2)
		if (istype(W, /obj/item/weapon/wrench))
			if (src.d_state == 4)
				var/turf/T = user.loc
				user << "\blue Cutting support rods."
				sleep(40)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 5
					user << "\blue You cut the support rods."
		else if (istype(W, /obj/item/weapon/wirecutters))
			if (src.d_state == 0)
				src.d_state = 1
				new /obj/item/weapon/rods( src )

		else if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
			if (W:weldfuel < 5)
				user << "\blue You need more welding fuel to complete this task."
				return
			W:weldfuel -= 5
			if (src.d_state == 2)
				var/turf/T = user.loc
				user << "\blue Slicing metal cover."
				sleep(60)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 3
					user << "\blue You sliced the metal cover."
			else if (src.d_state == 5)
				var/turf/T = user.loc
				user << "\blue Removing support rods."
				sleep(100)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 6
					new /obj/item/weapon/rods( src )
					user << "\blue You removed the support rods."
			else if (src.d_state == 8)
				user << "\blue You ignite the thermite!"
				sleep(15)
				src.icon_state = "r_wall-rst-3"
				sleep(15)
				src.icon_state = "r_wallmelt1"
				sleep(15)
				src.icon_state = "r_wallmelt2"
				sleep(15)
				src.icon_state = "r_wallmelt3"
				sleep(15)
				src.icon_state = "r_wallmelt4"
				src.d_state = 7
//				src.icon_state = "r_girder"
				sleep (15)
//				new /obj/item/weapon/rods( src )
//				new /obj/item/weapon/rods( src )
//				new /obj/item/weapon/sheet/metal( src )
//				new /obj/item/weapon/sheet/metal( src )
		else if (istype(W, /obj/item/weapon/screwdriver))
			if (src.d_state == 1)
				var/turf/T = user.loc
				user << "\blue Removing support lines."
				sleep(40)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 2
					user << "\blue You removed the support lines."
		else if (istype(W, /obj/item/weapon/crowbar))
			if (src.d_state == 3)
				var/turf/T = user.loc
				user << "\blue Prying cover off."
				sleep(100)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 4
					user << "\blue You pryed the cover off."
			else if (src.d_state == 6)
				var/turf/T = user.loc
				user << "\blue Prying outer sheath off."
				sleep(100)
				if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
					src.d_state = 7
					new /obj/item/weapon/sheet/metal( src )
		else if (istype(W, /obj/item/weapon/sheet/metal))
			var/turf/T = user.loc
			user << "\blue Repairing wall."
			sleep(100)
			if ((user.loc == T && user.equipped() == W && !( user.stat )  && istype(src, /turf/station/r_wall) && src.state == 2))
				src.d_state = 0
				user << "\blue You have repaired the wall."
				if (W:amount > 1)
					W:amount--
				else
					del(W)
	if (src.state == 1)
		if (istype(W, /obj/item/weapon/wrench))
			user << "\blue Now dismantling girders."
			var/turf/T = user.loc
			sleep(100)
			if ((user.loc == T && user.equipped() == W && !( user.stat )) && istype(src, /turf/station/r_wall))
				src.state = 0
				//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
				var/turf/station/floor/F = src.ReplaceWithFloor()
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				F.buildlinks()
				F.levelupdate()
		else if (istype(W, /obj/item/weapon/sheet/r_metal))
			src.state = 2
			src.d_state = 0
			del(W)
	if(istype(src,/turf/station/r_wall))
		src.update()
	return

/turf/station/r_wall/attack_paw(mob/user as mob)
	if (usr.ishulk)
		if (prob(5))
			var/B = pick(1,2,3,4,5,6)
			src.hear_sound("sound/damage/wall/impact[B].wav",6)
			usr << text("\blue You smash through the wall.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the wall.", usr)
			src.state = 0
			var/turf/station/floor/F = src.ReplaceWithFloor()
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/rods( F )
			F.buildlinks()
			F.levelupdate()
			return
		else
			usr << text("\blue You punch the wall.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] punches the wall.", usr)
			return

/turf/station/r_wall/attack_hand(mob/user as mob)
	if (usr.ishulk || usr.is_rev=="no")
		var/B = pick(1,2,3,4,5,6)
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		if (prob(5)||(usr.is_rev=="no"&&prob(15)))
			usr << text("\blue You smash through the wall.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the wall.", usr)
			src.state = 0
			var/turf/station/floor/F = src.ReplaceWithFloor()
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/rods( F )
			F.buildlinks()
			F.levelupdate()
			return
		else
			usr << text("\blue You punch the wall.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] punches the wall.", usr)
			return
	if (usr.zombie)
		var/B = pick(1,2,3,4,5,6)
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		var/Dodmg = 0
		for(var/mob/O in range(3,src)) // when zombie's swarm, they do more damage.
			if (O.zombie)
				Dodmg += 8
		Dodmg -= 8
		if(usr.zombieleader)
			Dodmg += 8
		if(Dodmg == 0)
			usr << "\blue Your lonely zombie claws arent strong enough to break the reinforced wall by yourself,<br>find other zombies and work together!"
		if(Dodmg > 0)
			usr << "\blue You claw the reinforced wall."
			hitpoints -= Dodmg
			if (hitpoints <= 0)
				usr << text("\blue You claw through the wall.")
				for(var/mob/O in oviewers())
					if ((O.client && !( O.blinded )))
						O << text("\red [] claws through the wall.", usr)
				src.state = 0
				var/turf/station/floor/F = src.ReplaceWithFloor()
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/rods( F )
				F.buildlinks()
				F.levelupdate()
				return
	user << "\blue You push the wall but nothing happens!"
	src.add_fingerprint(user)
	return

//routine above sometimes erroneously calls turf/station/floor/update
//src being miss-set somehow? Maybe due to multiple-clicking
/turf/station/floor/proc/update()
	return

/turf/station/wall/examine()
	set src in oview(1)

	usr << "It looks like a regular wall."
	return

/turf/station/wall/updatecell()

	if (src.state == 2)
		return
	else
		..()
	return


/turf/station/wall/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			var/turf/space/S = src.ReplaceWithSpace()
			S.buildlinks()
			del(src)
			return
		if(2.0)
			if (prob(50))
				src.opacity = 0
				src.updatecell = 1
				buildlinks()
				src.state = 1
				src.intact = 0
				src.levelupdate()
				new /obj/item/weapon/sheet/metal( src )
				new /obj/item/weapon/sheet/metal( src )
				src.icon_state = "girder"
			else
				src.state = 0
				//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
				var/turf/station/floor/F = src.ReplaceWithFloor()
				F.burnt = 1
				F.health = 30
				F.icon_state = "Floor1"
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				F.buildlinks()
				F.levelupdate()
		if(3.0)
			if (prob(25))
				src.opacity = 0
				src.updatecell = 1
				buildlinks()
				src.intact = 0
				levelupdate()
				src.state = 1
				new /obj/item/weapon/sheet/metal( src )
				new /obj/item/weapon/sheet/metal( src )
				src.icon_state = "girder"
		else
	return
/*
/turf/proc/hotcheck()		// this should go elsewhere but who gives a FUCK
	if (src.name == "space" || src.name == "Space")
		return			//space doesnt glow you dumbfucks
	if (src.temp >= 125000)
		src.icon += rgb(150,50,50)
	if (src.temp > 750)
		src.icon += rgb((src.temp / 1000),(src.temp / 5000),(src.temp / 5000))
	if (src.temp < 1500)
		if (src.icon != "wall.dmi")
		src.icon -= rgb(255,255,255)
		if (src.state != 1)
			src.icon_state = "wall"
		else if (src.state == 1)
			src.icon_state = "girders"
*/


/turf/station/wall/blob_act()

	if(prob(20))
		if(!intact)
			src.state = 0
			//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
			var/turf/station/floor/F = src.ReplaceWithFloor()
			F.burnt = 1
			F.health = 30
			F.icon_state = "Floor1"
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()
		else
			src.opacity = 0
			src.updatecell = 1
			buildlinks()
			src.state = 1
			src.intact = 0
			levelupdate()
			new /obj/item/weapon/sheet/metal( src )
			src.icon_state = "girder"



/turf/station/wall/unburn()
	src.sd_SetLuminosity(0)
	if (src.state == 1)
		src.icon_state = "girder"
	else
		src.icon_state = ""
	return

/turf/station/wall/attack_paw(mob/user as mob)
	if (usr.ishulk)
		var/B = pick(1,2,3,4,5,6)
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		if (prob(20))
			usr << text("\blue You smash through the wall.")
			src.state = 0
			var/turf/station/floor/F = src.ReplaceWithFloor()
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()
			return
		else
			usr << text("\blue You punch the wall.")
			return

	return src.attack_hand(user)

/turf/station/wall/attack_hand(mob/user as mob)
	if (usr.ishulk || usr.is_rev=="no")
		var/B = pick(1,2,3,4,5,6)
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		if (prob(20)||(usr.is_rev=="no"&&prob(25)))
			usr << text("\blue You smash through the wall.")
			src.state = 0
			var/turf/station/floor/F = src.ReplaceWithFloor()
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()
			return
		else
			usr << text("\blue You punch the wall.")
			return
	if (usr.zombie)
		var/B = pick(1,2,3,4,5,6)
		var/Dodmg = 0
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		for(var/mob/O in range(3,src)) // when zombie's swarm, they do more damage.
			if (O.zombie)
				Dodmg += 4
		if(Dodmg == 0)
			usr << "\blue You only barely dent the wall, swarm together with other zombies to break it faster!"
		usr << "\blue You slightly dent the wall, swarm together with other zombies to break it faster!"
		hitpoints -= Dodmg
		if (hitpoints <= 0)
			usr << text("\blue You claw through the wall.")
			src.state = 0
			var/turf/station/floor/F = src.ReplaceWithFloor()
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()

	user << "\blue You push the wall but nothing happens!"
	src.add_fingerprint(user)
	return

/turf/station/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if(istype(W, /obj/item/weapon/healthanalyzer))
		if (!blood)
			return
		user << text("You have extracted the following DNA sequence from the blood: [src.blood] ")
		if(src.zombieblood == 1)
			user << text("Contains traces of a unknown infectious agent")
		return
	if(istype(W,/obj/item/weapon/food/butterknife))
		if(!blood)
			return
		var/obj/item/weapon/food/butterknife/G = W
		G.gotblood = 1
		G.overlays += "blood"
		for(var/mob/C in viewers())
			C.show_message("[user] puts some blood on [W]")
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if ((istype(W, /obj/item/weapon/wrench) && src.state == 1))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return
		user << "\blue Now dissembling the girders. Please stand still. This is a long process."
		sleep(100)
		if (!( istype(src, /turf/station/wall) ))
			return
		if ((user.loc == T && src.state == 1 && user.equipped() == W))
			src.state = 0
			//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
			var/turf/station/floor/F = src.ReplaceWithFloor()
//			F.oxygen = O2STANDARD
			new /obj/item/weapon/sheet/metal( F )
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
			F.levelupdate()
	else if ((istype(W, /obj/item/weapon/screwdriver) && src.state == 1))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return
		user << "\blue Now dislodging girders."
		sleep(100)
		if (!( istype(src, /turf/station/wall) ))
			return
		if ((user.loc == T && src.state == 1 && user.equipped() == W))
			src.state = 0
			//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
			var/turf/station/floor/F = src.ReplaceWithFloor()
//			F.oxygen = O2STANDARD
			new /obj/d_girders( F )
			new /obj/item/weapon/sheet/metal( F )
			F.buildlinks()
	else if (istype(W, /obj/item/weapon/sheet/r_metal) && src.state == 1)
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return
		user << "\blue Now reinforcing girders."
		sleep(100)
		if (!( istype(src, /turf/station/wall) ))
			return
		if ((user.loc == T && src.state == 1 && user.equipped() == W))
			src.state = 0
			//var/turf/station/r_wall/F = new /turf/station/r_wall( locate(src.x, src.y, src.z) )
			var/turf/station/r_wall/F = src.ReplaceWithRWall()
//			F.oxygen = O2STANDARD
			F.icon_state = "r_girder"
			F.state = 1
			F.opacity = 0
			F.updatecell = 1
			F.levelupdate()
			F.buildlinks()
	else if (istype(W, /obj/item/weapon/weldingtool) && src.state == 2 && W:welding)
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return
		if (W:weldfuel < 5)
			user << "\blue You need more welding fuel to complete this task."
			return
		W:weldfuel -= 5
		user << "\blue Now dissembling the outer wall plating. Please stand still."
		sleep(100)
		if ((user.loc == T && src.state == 2 && user.equipped() == W))
			src.opacity = 0
			src.updatecell = 1
			src.buildlinks()
			src.state = 1
			src.intact = 0
			src.levelupdate()
			new /obj/item/weapon/sheet/metal( src )
			new /obj/item/weapon/sheet/metal( src )
			src.icon_state = "girder"
	else if (istype(W, /obj/item/weapon/sheet/metal) && src.state == 1 && W:amount >= 2)
		var/turf/T = user.loc
		if (!istype(T, /turf))
			return
		if (user.loc == src.loc) //on the wall!
			user << "\blue Move off the wall before trying to finish it!"
		user << "\blue Now adding plating."
		sleep(30) //plating gets added fast! but not THAT fast
		if (!( istype(src, /turf/station/wall) ))
			return
		if (user.loc == T && src.state == 1 && user.equipped() == W && W:amount >= 2)
			src.icon_state = ""
			src.state = 2
			src.opacity = 1
			src.updatecell = 0
			src.intact = 1
			src.levelupdate()
			src.buildlinks()
			W:amount -= 2
			if(W:amount <= 0)
				del(W)
	else
		return attack_hand(user)
	return

/turf/station/wall/meteorhit(obj/M as obj)


	if (M.icon_state == "flaming")
		var/B = pick(1,2,3,4,5,6)
		src.hear_sound("sound/damage/wall/impact[B].wav",6)
		src.icon_state = "girder"
		if (src.state == 2)
			src.state = 1
			src.opacity = 0
			src.updatecell = 1
			src.intact = 0
			src.levelupdate()
			src.buildlinks()
			src.firelevel = 11
			new /obj/item/weapon/sheet/metal( src )
			new /obj/item/weapon/sheet/metal( src )
		else
			if ((prob(20) && src.state == 1))
				src.state = 0
				//var/turf/station/floor/F = new /turf/station/floor( locate(src.x, src.y, src.z) )
				var/turf/station/floor/F = src.ReplaceWithFloor()
//				F.oxygen = O2STANDARD
				new /obj/item/weapon/sheet/metal( F )
				new /obj/item/weapon/sheet/metal( F )
				F.buildlinks()
				F.levelupdate()
	return

/turf/station/floor/CheckPass(atom/movable/O as mob|obj)

	if ((istype(O, /obj/machinery/vehicle) && !(src.burnt)))
		if (!( locate(/obj/machinery/mass_driver, src) ))
			return 0
	return 1

/turf/station/floor/ex_act(severity)
	set src in oview(1)

	switch(severity)
		if(1.0)
			var/turf/space/S = src.ReplaceWithSpace()
			S.buildlinks()
			levelupdate()
			//del(src)	//deleting it makes this method silently stop executing and erases the saved area somehow (SL)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				var/turf/space/S = src.ReplaceWithSpace()
				S.buildlinks()
				levelupdate()
				//del(src)	//deleting it makes this method silently stop executing and erases the saved area somehow (SL)
				return
			else
				src.icon_state = "burning"
				src.sd_SetLuminosity(2)
				src.burnt = 1
				src.health = 30
				src.intact = 0
				levelupdate()
				src.firelevel = 1800000.0
				src.buildlinks()
		if(3.0)
			if (prob(50))
				src.burnt = 1
				src.health = 1
				src.intact = 0
				levelupdate()
				src.icon_state = "Floor1"
				src.buildlinks()
		else
	return

/turf/station/floor/blob_act()
	return

/turf/station/floor/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/station/floor/attack_hand(mob/user as mob)

	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/station/floor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/crowbar))
		if (src.health <= 100) return
		src.health	= 100
		src.burnt	= 1
		src.intact	= 0
		levelupdate()
		new /obj/item/weapon/tile(src)
		src.icon_state = text("Floor[]", (src.burnt ? "1" : ""))
		return

	if(istype(C, /obj/item/weapon/tile))
		if(src.health > 100) return
		src.health	= 150
		src.burnt	= 0
		src.intact	= 1
		levelupdate()
		if (src.firelevel >= 900000.0)
			src.icon_state = "burning"
			src.sd_SetLuminosity(2)
		else
			src.icon_state = "Floor"
		var/obj/item/weapon/tile/T = C
		if(--T.amount < 1)
			del(T)
			return

	if(istype(C, /obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/coil = C
		coil.turf_place(src, user)
	if(istype(C, /obj/item/weapon/pipe))
		var/obj/item/weapon/pipe/p = C
		p.turf_place(src, user)

/turf/station/floor/unburn()
	src.sd_SetLuminosity(0)
	src.icon_state = text("Floor[]", (src.burnt ? "1" : ""))
	return

/turf/station/floor/updatecell()
	..()
	if (src.checkfire)
		if (src.firelevel >= 2700000.0)
			src.health--
		if (src.health <= 0)
			src.burnt = 1
			src.intact = 0
			levelupdate()
			//SN src = null
			del(src)
			return
		else
			if (src.health <= 100)
				src.burnt = 1
				src.intact = 0
				levelupdate()
	return

/turf/station/floor/plasma_test/updatecell()
	..()
	src.poison = 7.5E7
	res_vars()
	return

/obj/shuttle/door/meteorhit(obj/M as obj)
	src.open()
	return

/turf/station/shuttle/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			var/turf/space/S = src.ReplaceWithSpace()
			S.buildlinks()

			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				var/turf/space/S = src.ReplaceWithSpace()
				S.buildlinks()

				del(src)
				return
		else
	return

/turf/station/shuttle/blob_act()
	if(prob(20))

		var/turf/space/S = src.ReplaceWithSpace()
		S.buildlinks()

		del(src)

obj/bloodtemplate/New()
	for(var/turf/station/wall/M in range(1, src))
		if (M.state == 2)
			if (prob(50))
				M.icon_state = "wall-blood-[pick("1","2","3","4","5","6")]"
				M.blood = src.blood
	icon_state = "floor[pick("1","2","3","4","5","6","7")]"
	if (hulk == 1)
		src.icon += rgb(0,100,0)
	return
obj/bloodtemplate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/healthanalyzer/))
		if (!blood)
			return
		user << text("You have extracted the following DNA sequence from the blood: [src.blood] ")
		if(src.zombieblood == 1)
			user << text("Contains traces of a unknown infectious agent")
	if(istype(W,/obj/item/weapon/food/butterknife))
		if(!blood)
			return
		var/obj/item/weapon/food/butterknife/G = W
		G.gotblood = 1
		G.overlays += blood
		for(var/mob/X in viewers())
			X.show_message("[user] puts some blood on [W]")
		return

/obj/item/weapon/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/healthanalyzer/))
		if (!blood)
			return
		user << text("You have extracted the following DNA sequence from the blood: [src.blood] ")
		if(src.zombieblood == 1)
			user << text("Contains traces of a unknown infectious agent")
	return ..()