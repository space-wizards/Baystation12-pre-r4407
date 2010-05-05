/obj/machinery/camera/attack_ai(var/mob/ai/user as mob)
	if (src.network != user.network || !(src.status))
		return
	user.current = src
	user.reset_view(src)

/obj/machinery/camera/attackby(W as obj, user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		src.status = !( src.status )
		if (!( src.status ))
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] has deactivated []!", user, src), 1)
			src.icon_state = "camera1"
		else
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] has reactivated []!", user, src), 1)
			src.icon_state = "camera"
		// now disconnect anyone using the camera
		for(var/mob/ai/O in world)
			if (O.current == src)
				O.cancel_camera()
				O << "Your connection to the camera has been lost."
		for(var/mob/O in world)
			if (istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if (S.current == src)
					O.machine = null
					S.current = null
					O.reset_view(null)
					O << "The screen bursts into static."
	else if (istype(W, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/X = W
		for(var/mob/ai/O in world)
			if (O.current == src)
				O << "[user] holds a paper up to the camera ..."
				user << "You hold a paper up to the camera ..."
				O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
		for(var/mob/O in world)
			if (istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if (S.current == src)
					O << "[user] holds a paper up to the camera ..."
					user << "You hold a paper up to the camera ..."
					O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
	return

/obj/machinery/sec_lock/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/sec_lock/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/sec_lock/attack_hand(var/mob/user as mob)
	if(..())
		return
	use_power(10)

	if (src.loc == user.loc)
		var/dat = text("<B>Security Pad:</B><BR>\nKeycard: []<BR>\n<A href='?src=\ref[];door1=1'>Toggle Outer Door</A><BR>\n<A href='?src=\ref[];door2=1'>Toggle Inner Door</A><BR>\n<BR>\n<A href='?src=\ref[];em_cl=1'>Emergency Close</A><BR>\n<A href='?src=\ref[];em_op=1'>Emergency Open</A><BR>", (src.scan ? text("<A href='?src=\ref[];card=1'>[]</A>", src, src.scan.name) : text("<A href='?src=\ref[];card=1'>-----</A>", src)), src, src, src, src)
		user << browse(dat, "window=sec_lock")
	return

/obj/machinery/sec_lock/attackby(nothing, user as mob)
	return src.attack_hand(user)

/obj/machinery/sec_lock/New()
	..()
	spawn( 2 )
		if (src.a_type == 1)
			src.d2 = locate(/obj/machinery/door, locate(src.x - 2, src.y - 1, src.z))
			src.d1 = locate(/obj/machinery/door, get_step(src, SOUTHWEST))
		else
			if (src.a_type == 2)
				src.d2 = locate(/obj/machinery/door, locate(src.x - 2, src.y + 1, src.z))
				src.d1 = locate(/obj/machinery/door, get_step(src, NORTHWEST))
			else
				src.d1 = locate(/obj/machinery/door, get_step(src, SOUTH))
				src.d2 = locate(/obj/machinery/door, get_step(src, SOUTHEAST))
		return
	return

/obj/machinery/sec_lock/Topic(href, href_list)
	if(..())
		return
	if ((!( src.d1 ) || !( src.d2 )))
		usr << "\red Error: Cannot interface with door security!"
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf)) || (istype(usr, /mob/ai))))
		usr.machine = src
		if (href_list["card"])
			if (src.scan)
				src.scan.loc = src.loc
				src.scan = null
			else
				var/obj/item/weapon/card/id/I = usr.equipped()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					src.scan = I
		if (href_list["door1"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (src.d1.density)
						spawn( 0 )
							src.d1.open()
							return
					else
						spawn( 0 )
							src.d1.close()
							return
		if (href_list["door2"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (src.d2.density)
						spawn( 0 )
							src.d2.open()
							return
					else
						spawn( 0 )
							src.d2.close()
							return
		if (href_list["em_cl"])
			if (src.scan)
				if (src.check_access(src.scan))
					if (!( src.d1.density ))
						src.d1.close()
						return
					sleep(1)
					spawn( 0 )
						if (!( src.d2.density ))
							src.d2.close()
						return
		if (href_list["em_op"])
			if (src.scan)
				if (src.check_access(src.scan))
					spawn( 0 )
						if (src.d1.density)
							src.d1.open()
						return
					sleep(1)
					spawn( 0 )
						if (src.d2.density)
							src.d2.open()
						return
		src.add_fingerprint(usr)
		src.updateUsrDialog()
	return

/obj/machinery/autolathe/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/sheet/metal))
		if (src.m_amount < 1500000.0)
			src.m_amount += O:height * O:width * O:length * 1000000.0
			O:amount--
			if (O:amount < 1)
				//O = null
				del(O)
	else
		if (istype(O, /obj/item/weapon/sheet/glass))
			if (src.g_amount < 750000.0)
				src.g_amount += O:height * O:width * O:length * 1000000.0
				O:amount--
				if (O:amount < 1)
					//O = null
					del(O)
		else
			if (istype(O, /obj/item/weapon/screwdriver))
				if (!( src.operating ))
					src.opened = !( src.opened )
					src.icon_state = text("autolathe[]", (src.opened ? "f" : null))
				else
					user << "\red The machine is in use. You can not maintain it now."
			else
				spawn( 0 )
					src.attack_hand(user)
					return
	return

/obj/machinery/autolathe/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/autolathe/attack_hand(user as mob)
	if(..())
		return
	var/dat
	if (src.temp)
		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];temp=1'>Clear Screen</A>", src.temp, src)
	else
		dat = text("<B>Metal Amount:</B> [] cm<sup>3</sup> (MAX: 1,500,000)<BR>\n<FONT color = blue><B>Glass Amount:</B></FONT> [] cm<sup>3</sup> (MAX: 750,000)<HR>", src.m_amount, src.g_amount)
		var/list/L = list(  )
		L["screwdriver"] = "Make a Screwdriver {1200 cc Metal}"
		L["wirecutters"] = "Make Wirecutters {1800 cc Metal}"
		L["wrench"] = "Make a Wrench {7500 cc Metal}"
		L["crowbar"] = "Make a Crowbar {10000 cc Metal}"
		L["welder"] = "Make a Welder {5000 cc Metal ; 1000 cc Glass}"
		L["multitool"] = "Make a Multitool {2000 cc Metal ; 3000 cc Glass}"
	//	L["screw"] = "Make Screw (1) {3 cc}"
	//	L["5screws"] = "Make Screws (5) {14 cc}"
		L["rod"] = "Make Rods {18750 cc Metal}"
		L["metal_s"] = "Make a Metal Sheet {37500 cc Metal}"
		L["metal_s"] = "Make a Reinforced Metal Sheet {75000 cc Metal}"
		L["glass_s"] = "Make a Glass Sheet {37500 cc Glass}"
		L["glass_r"] = "Make a Reinforced Glass Sheet {18750 cc Metal ; 37500 cc Glass}"
	//	L["rod_l"] = "Make Rod (5x250) {1250 cc}"
	//	L["grille_1"] = "Make Grille (250x250x1) {27345 cc}"
	//	L["sheet_1"] = "Make Sheet (20x10x.01) {2 cc}"
	//	L["sheet_2"] = "Make Sheet (30x10x.01) {3 cc}"
	//	L["sheet_3"] = "Make Sheet (30x20x.01) {6 cc}"
	//	L["sheet_4"] = "Make Sheet (30x30x.01) {9 cc}"
	//	L["sheet_5"] = "Make Sheet (62.5x62.5x4) {15625 cc}"
		L["pipe"] = "Make a Pipe {37500 cc Metal}"
		L["pipe-c"] = "Make a Corner Pipe {37500 cc Metal}"
		L["pipe-h"] = "Make a Heat Exchange Pipe {37500 cc Metal}"
		L["pipe-hc"] = "Make a Heat Exchange Corner Pipe {37500 cc Metal}"
		L["manifold"] = "Make a Manifold Pipe {75000 cc Metal}"
		L["connector"] = "Make a Connector {56250 cc Metal}"
		L["mvalve"] = "Make a Manual Valve {56250 cc Metal ; 18750 cc Glass}"
		L["dvalve"] = "Make a Digital Valve {56250 cc Metal ; 18750 cc Glass}"
		L["vent"] = "Make a Vent {75000 cc Metal}"
		L["inlet"] = "Make a Inlet {75000 cc Metal}"
		L["junction"] = "Make a Junction {56250 cc Metal}"
		L["filter"] = "Make a Filter {75000 cc Metal ; 37500 cc Glass}"
		L["oneway"] = "Make a One-way Pipe{56250 cc Metal}"
		L["pump"] = "Make a Pipe Pump {56250 cc Metal ; 18750 cc Glass}"



		for(var/t in L)
			dat += "<A href='?src=\ref[src];make=[t]'>[L["[t]"]]<BR>"
	user << browse("<HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=autolathe")
	return

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)

	if (href_list["temp"])
		src.temp = null
	if(href_list["make"])

		var/list/C = list()
		C["screwdriver"] = 1200
		C["wirecutters"] = 1800
		C["wrench"] = 7500
		C["crowbar"] = 10000
		C["welder"] = 5000
		C["multitool"] = 2000
		C["rod"] = 18749
		C["metal_s"] = 37499
		C["metal_r"] = 74999
		C["glass_s"] = 0
		C["glass_r"] = 18749
		C["pipe"] = 37500
		C["pipe-c"] = 37500
		C["pipe-h"] = 37500
		C["pipe-hc"] = 37500
		C["manifold"] = 75000
		C["connector"] = 56250
		C["mvalve"] = 56250
		C["dvalve"] = 56250
		C["vent"] = 75000
		C["inlet"] = 75000
		C["junction"] = 56250
		C["filter"] = 75000
		C["oneway"] = 56250
		C["pump"] = 56250

		var/list/D = list()
		D["screwdriver"] = 0
		D["wirecutters"] = 0
		D["wrench"] = 0
		D["crowbar"] = 0
		D["welder"] = 1000
		D["multitool"] = 3000
		D["rod"] = 0
		D["metal_s"] = 0
		D["metal_r"] = 0
		D["glass_s"] = 37499
		D["glass_r"] = 37499
		D["pipe"] = 0
		D["pipe-c"] = 0
		D["pipe-h"] = 0
		D["pipe-hc"] = 0
		D["manifold"] = 0
		D["connector"] = 0
		D["mvalve"] = 18750
		D["dvalve"] = 18750
		D["vent"] = 0
		D["inlet"] = 0
		D["junction"] = 0
		D["filter"] = 37500
		D["oneway"] = 0
		D["pump"] = 18750


		var/item = href_list["make"]
		var/cost = C[item]
		var/g_cost = D[item]

		if(m_amount >= cost)
			if (g_amount >= g_cost)
				m_amount -= cost
				g_amount -= g_cost
				operate()
				switch(item)
					if("screwdriver")
						new /obj/item/weapon/screwdriver(src.loc)
					if("wirecutters")
						new /obj/item/weapon/wirecutters(src.loc)
					if("wrench")
						new /obj/item/weapon/wrench(src.loc)
					if("crowbar")
						new /obj/item/weapon/crowbar(src.loc)
					if("welder")
						new /obj/item/weapon/weldingtool(src.loc)
					if("multitool")
						new /obj/item/weapon/multitool(src.loc)
					if("rod")
						new /obj/item/weapon/rods(src.loc)
					if ("metal_s")
						new /obj/item/weapon/sheet/metal(src.loc)
					if ("metal_r")
						new /obj/item/weapon/sheet/r_metal(src.loc)
					if ("glass_s")
						new /obj/item/weapon/sheet/glass(src.loc)
					if ("glass_r")
						new /obj/item/weapon/sheet/rglass(src.loc)
					if ("pipe")
						new /obj/item/weapon/pipe(src.loc)
					if ("pipe-c")
						new /obj/item/weapon/pipe/corner(src.loc)
					if ("pipe-h")
						new /obj/item/weapon/pipe/he(src.loc)
					if ("pipe-hc")
						new /obj/item/weapon/pipe/he/corner(src.loc)
					if ("manifold")
						new /obj/item/weapon/pipe/manifold(src.loc)
					if ("connector")
						new /obj/item/weapon/pipe/connector(src.loc)
					if ("mvalve")
						new /obj/item/weapon/pipe/valve(src.loc)
					if ("dvalve")
						new /obj/item/weapon/pipe/valve/digital(src.loc)
					if ("vent")
						new /obj/item/weapon/pipe/vent(src.loc)
					if ("inlet")
						new /obj/item/weapon/pipe/inlet(src.loc)
					if ("junction")
						new /obj/item/weapon/pipe/junction(src.loc)
					if ("filter")
						new /obj/item/weapon/pipe/filter(src.loc)
					if ("oneway")
						new /obj/item/weapon/pipe/oneway(src.loc)
					if ("pump")
						new /obj/item/weapon/pipe/oneway/pump(src.loc)
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)
	return
/obj/machinery/autolathe/proc/operate()

		use_power(500)
		operating = 1
		flick("autolathe_c", src)
		sleep(16)
		flick("autolathe_o", src)
		sleep(8)
		operating = 0

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(25))
				del(src)
				return
		else
	return

/obj/machinery/blob_act()
	if(prob(25))
		del(src)

/obj/machinery/injector/attackby(var/obj/item/weapon/tank/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	use_power(25, EQUIP)

	var/obj/item/weapon/tank/ptank = W
	if (!( istype(ptank, /obj/item/weapon/tank) ))
		return
	var/turf/T = get_step(src.loc, get_dir(user, src))
	ptank.gas.turf_add(T, -1.0)
	src.add_fingerprint(user)
	return

/obj/machinery/alarm/process()
	var/turf/T = src.loc
	var/area/A = T.loc
	var/safe = 2

	if(stat & (NOPOWER|BROKEN))
		icon_state = "alarm-p"
		A.atmosalert(safe, src)
		return

	use_power(5, ENVIRON)

	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	var/turf_total = T.per_turf()//T.co2 + T.oxygen + T.poison() + T.sl_gas + T.n2
	turf_total = max(turf_total, 1)

	//if (!( (75 < t1 && t1 < 125) ))
	//	safe = 0
	//if (!( (20 < t2 && t2 < 30) ))
	//	safe = 0

	var/temp = T.temp()	// temperature of turf
	var/P    = turf_total / CELLSTANDARD // pressure in bar

	var/ppO2   = P * (T.oxygen / turf_total)
	var/ppCO2  = P * (T.co2 / turf_total)
	var/ppPlas = P * (T.poison() / turf_total)

	// world.log << "[A.name] : P = [P] | FO2 = [FO2] | ppO2 = [ppO2]"
	if (P < 0.90 || P > 1.10) // pressure alarm
		safe = (P < 0.75 || P > 1.25) ? 0 : 1
	if (safe && (ppO2 < 0.19 || ppO2 > 0.23)) // O2 alarm
		safe = (ppO2 < 0.17 || ppO2 > 0.25) ? 0 : 1
	if (safe && (ppCO2 > 0.05)) // CO2 alarm
		safe = (ppCO2 > 0.1) ? 0 : 1
	if (safe && (ppPlas > 0.05)) // Plasma alarm
		safe = (ppPlas > 0.1) ? 0 : 1
	if (safe && (temp > 325.444 || temp < 283.591))
		safe = (temp > 326.444 || temp < 282.591) ? 0 : 1

	if(safe == old_safe)
		return
	old_safe = safe
	A.atmosalert(safe, src)
	src.icon_state = text("alarm:[]", !( safe == 2 ))

	return

/obj/machinery/alarm/attackby(W as obj, user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		stat ^= BROKEN
		src.add_fingerprint(user)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] has []activated []!", user, (stat & BROKEN) ? "de" : "re", src), 1)
		return
	return ..()

/obj/machinery/alarm/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/alarm/attack_hand(var/mob/M)
	if(..())
		return
	var/turf/T = get_turf(loc)

	var/turf_total = T.per_turf()//T.co2 + T.oxygen + T.poison() + T.sl_gas + T.n2
	turf_total = max(turf_total, 1)

	M << "\blue <B>Results:</B>"

	var/t = ""
	var/t1 = turf_total / CELLSTANDARD * 100

	if ((90 < t1 && t1 < 110))
		M << text("\blue Air Pressure: []%", t1)
	else
		M << text("\blue Air Pressure:\red []%", t1)

	t1 = T.n2() / turf_total * 100
	t1 = round(t1, 0.0010)

	if ((60 < t1 && t1 < 80))
		t += text("<font color=blue>Nitrogen: []</font> ", t1)
	else
		t += text("<font color=red>Nitrogen: []</font> ", t1)
	t1 = T.oxygen() / turf_total * 100
	t1 = round(t1, 0.0010)

	if ((20 < t1 && t1 < 24))
		t += text("<font color=blue>Oxygen: []</font> ", t1)
	else
		t += text("<font color=red>Oxygen: []</font> ", t1)

	t1 = T.poison() / turf_total * 100
	t1 = round(t1, 0.0010)

	if (t1 < 0.5)
		t += text("<font color=blue>Plasma: []</font> ", t1)
	else
		t += text("<font color=red>Plasma: []</font> ", t1)

	t1 = T.co2() / turf_total * 100
	t1 = round(t1, 0.0010)

	if (t1 < 1)
		t += text("<font color=blue>CO2: []</font> ", t1)
	else
		t += text("<font color=red>CO2: []</font> ", t1)
	t1 = T.sl_gas() / turf_total * 100
	t1 = round(t1, 0.0010)

	if (t1 < 5)
		t += text("<font color=blue>NO2: []</font>", t1)
	else
		t += text("<font color=red>NO2: []</font>", t1)

	t1 = T.temp() - T0C
	if (T.temp() > 326.444 || T.temp() < 282.591)
		t += text("<br><font color=red>Temperature: []</font>", t1)
	else
		t += text("<br><font color=blue>Temperature: []</font>", t1)

	M << t
	return

/obj/machinery/alarm/indicator/process()
	if(stat & NOPOWER)
		icon_state = "indicator-p"
		return

	var/safe = 1
	var/turf/T = src.loc
	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	var/turf_total = T.per_turf()//T.co2 + T.oxygen + T.poison() + T.sl_gas + T.n2
	turf_total = max(turf_total, 1)
	var/t1 = turf_total / CELLSTANDARD * 100
	if (!( (90 < t1 && t1 < 110) ))
		safe = 0
	t1 = T.oxygen() / turf_total * 100
	if (!( (20 < t1 && t1 < 30) ))
		safe = 0
	src.icon_state = text("indicator[]", safe)
	return