//A pair of procs as a fuck-you to metagamers
/obj/item/weapon/disk/nuclear/New()
	..()
	spawn(0)
		while (1)
			sleep(50)
			if (roundover)
				return
			var/turf/L = get_turf(src)
			if (!(L.z in stationfloors) && ticker.mode.name == "nuclear emergency")
				world << "\red The Nuclear Disk is no longer in play"
				world << "\red Creating new disk at nuclear bomb location"
				world << "<B>Next time don't eject the disk!</B>"
				var/turf/T = get_turf(locate(/obj/machinery/nuclearbomb))
				new /obj/item/weapon/disk/nuclear(T)
				return

/obj/item/weapon/disk/nuclear/Del()
	if (!roundover && ticker.mode.name == "nuclear emergency")
		world << "\red Nuclear Disk Destroyed!"
		world << "\red Creating new disk at nuclear bomb location"
		world << "<B>Next time don't destroy the disk!</B>"
		var/turf/T = get_turf(locate(/obj/machinery/nuclearbomb))
		new /obj/item/weapon/disk/nuclear(T)
	..()

/obj/machinery/nuclearbomb/New()
	if (nuke_code)
		src.r_code = nuke_code
	..()
	return

/obj/machinery/nuclearbomb/process()
	if (src.timing)
		src.timeleft--
		if (src.timeleft <= 0)
			explode()
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
	return

/obj/machinery/nuclearbomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if (src.extended)
		user.machine = src
		var/dat = text("<TT><B>Nuclear Fission Explosive</B><BR>\nAuth. Disk: <A href='?src=\ref[];auth=1'>[]</A><HR>", src, (src.auth ? "++++++++++" : "----------"))
		if (src.auth)
			if (src.yes_code)
				dat += text("\n<B>Status</B>: []-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] <A href='?src=\ref[];timer=1'>Toggle</A><BR>\nTime: <A href='?src=\ref[];time=-10'>-</A> <A href='?src=\ref[];time=-1'>-</A> [] <A href='?src=\ref[];time=1'>+</A> <A href='?src=\ref[];time=10'>+</A><BR>\n<BR>\nSafety: [] <A href='?src=\ref[];safety=1'>Toggle</A><BR>\nAnchor: [] <A href='?src=\ref[];anchor=1'>Toggle</A><BR>\n", (src.timing ? "Func/Set" : "Functional"), (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src, src, src, src.timeleft, src, src, (src.safety ? "On" : "Off"), src, (src.anchored ? "Engaged" : "Off"), src)
			else
				dat += text("\n<B>Status</B>: Auth. S2-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\n[] Safety: Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
		else
			if (src.timing)
				dat += text("\n<B>Status</B>: Set-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
			else
				dat += text("\n<B>Status</B>: Auth. S1-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
		var/message = "AUTH"
		if (src.auth)
			message = text("[]", src.code)
			if (src.yes_code)
				message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
		dat += "<br><br><A HREF='?src=\ref[user];mach_close=communications'>Close</A>"
		user << browse(dat, "window=nuclearbomb;size=300x400")
	else if (src.deployable)
		src.anchored = 1
		flick("nuclearbombc", src)
		src.icon_state = "nuclearbomb1"
		src.extended = 1
	return

/obj/machinery/nuclearbomb/verb/make_deployable()
	set name = "make deployable"
	set src in oview(1)

	if (src.deployable)
		src.deployable = 0
	else
		src.deployable = 1

/obj/machinery/nuclearbomb/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["auth"])
			if (src.auth)
				src.auth.loc = src.loc
				src.yes_code = 0
				src.auth = null
			else
				var/obj/item/I = usr.equipped()
				if (istype(I, /obj/item/weapon/disk/nuclear))
					usr.drop_item()
					I.loc = src
					src.auth = I
		if (src.auth)
			if (href_list["type"])
				if (href_list["type"] == "E")
					if (src.code == src.r_code)
						src.yes_code = 1
						src.code = null
					else
						src.code = "ERROR"
				else
					if (href_list["type"] == "R")
						src.yes_code = 0
						src.code = null
					else
						src.code += text("[]", href_list["type"])
						if (length(src.code) > 5)
							src.code = "ERROR"
			if (src.yes_code)
				if (href_list["time"])
					var/time = text2num(href_list["time"])
					src.timeleft += time
					src.timeleft = min(max(round(src.timeleft), 5), 600)
				if (href_list["timer"])
					if (src.timing == -1.0)
						return
					src.timing = !( src.timing )
					if (src.timing)
						src.icon_state = "nuclearbomb2"
					else
						src.icon_state = "nuclearbomb1"
				if (href_list["safety"])
					src.safety = !( src.safety )
				if (href_list["anchor"])
					src.anchored = !( src.anchored )
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
	else
		usr << browse(null, "window=nuclearbomb")
		return
	return

/obj/machinery/nuclearbomb/ex_act()
	if (src.timing == -1.0)
		return
	else
		return ..()
	return


/obj/machinery/nuclearbomb/blob_act()
	if (src.timing == -1.0)
		return
	else
		return ..()
	return

/obj/machinery/nuclearbomb/proc/explode()
	spawn(0)
		if (src.safety)
			src.timing = 0
			return
		if (nuclearend)
			return
		if(ticker.mode.name == "nuclear emergency")
			world << "<FONT size = 3><B>Syndicate Victory</B></FONT>"
			world << "<B>The Syndicate have successfully blown the nuke.</B> Next time, don't let them get the disk!"
			nuclearend = 1
			sleep(450)
			world << "\blue Rebooting"
			world.Reboot()
			return
		src.timing = -1.0
		src.yes_code = 0
		src.icon_state = "nuclearbomb3"
		sleep(20)
		var/turf/T = src.loc
		while(!( istype(T, /turf) ))
			T = T.loc
		var/min = 50
		var/med = 250
		var/max = 500
		var/sw = locate(1, 1, T.z)
		var/ne = locate(world.maxx, world.maxy, T.z)

		defer_powernet_rebuild = 1

		var/num = 0
		for(var/turf/U in block(sw, ne))
			var/zone = 4
			if ((U.y <= T.y + max && U.y >= T.y - max && U.x <= T.x + max && U.x >= T.x - max))
				zone = 3
			if ((U.y <= T.y + med && U.y >= T.y - med && U.x <= T.x + med && U.x >= T.x - med))
				zone = 2
			if ((U.y <= T.y + min && U.y >= T.y - min && U.x <= T.x + min && U.x >= T.x - min))
				zone = 1
			for(var/atom/A in U)
				A.ex_act(zone)
			U.ex_act(zone)
			U.buildlinks()
			num++
			if(num>50)
				sleep(1)
				num = 0

		defer_powernet_rebuild = 0
		makepowernets()
		ticker.nuclear(src.z)
		del(src)
		return

/obj/machinery/nuclearbomb/ex_act(severity)
	switch(severity)
		if(1.0)
			return
		if(2.0)
			return
		if(3.0)
			return
		else
	return

