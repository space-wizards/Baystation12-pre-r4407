/obj/machinery/freezer/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/freezer/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/freezer/attack_hand(mob/user as mob)
	if(..())
		return
	user.machine = src

	if(istype(user, /mob/monkey))
		var/d1 = null
		if (locate(/obj/item/weapon/flasks, src))
			var/counter = 1
			for(var/obj/item/weapon/flasks/F in src)
				d1 += text("<A href = '?src=\ref[];flask=[]'><B>[] []</B></A>: []<BR>", src, counter, stars("Flask"), counter, stars(text("[] / [] / []", F.oxygen, F.plasma, F.coolant)))
				counter++
			d1 += "Key:    Oxygen / Plasma / Coolant<BR>"
		else
			d1 = "<B>No flasks!</B>"
		var/t1 = null
		switch(src.t_flags)
			if(0.0)
				t1 = text("<A href = '?src=\ref[];oxygen=1'>[]</A> <A href = '?src=\ref[];plasma=1'>[]</A>", src, stars("Oxygen-No"), src, stars("Plasma-No"))
			if(1.0)
				t1 = text("<A href = '?src=\ref[];oxygen=0'>[]</A> <A href = '?src=\ref[];plasma=1'>[]</A>", src, stars("Oxygen-Yes"), src, stars("Plasma-No"))
			if(2.0)
				t1 = text("<A href = '?src=\ref[];oxygen=1'>[]</A> <A href = '?src=\ref[];plasma=0'>[]</A>", src, stars("Oxygen-No"), src, stars("Plasma-Yes"))
			if(3.0)
				t1 = text("<A href = '?src=\ref[];oxygen=0'>[]</A> <A href = '?src=\ref[];plasma=0'>[]</A>", src, stars("Oxygen-Yes"), src, stars("Plasma-Yes"))
			else
		var/t2 = null
		if (src.status)
			t2 = text("Cooling-[] <A href = '?src=\ref[];cool=0'>[]</A>", src.c_used, src, stars("Stop"))
		else
			t2 = text("<A href = '?src=\ref[];cool=1'>Cool</A> []", src, stars("Stopped"))
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><BR>\n\t\t<B>[]</B>: []<BR>\n\t\t<B>[]</B>: []<BR>\n\t\t   <B>[]</B>: []<BR>\n\t\t<B>[]</B>: []<BR>\n\t\t   <A href='?src=\ref[];cp=-5'>-</A> <A href='?src=\ref[];cp=-1'>-</A> [] <A href='?src=\ref[];cp=1'>+</A> <A href='?src=\ref[];cp=5'>+</A><BR>\n<BR>\n\t[]<BR>\n<BR>\n<BR>\n\t<A href='?src=\ref[];mach_close=freezer'>Close</A>\n\t</TT></BODY></HTML>", stars("Temperature"), src.temperature-T0C, stars("Transfer Status"), (src.transfer ? text("Transfering <A href='?src=\ref[];transfer=0'>Stop</A>", src) : text("<A href='?src=\ref[];transfer=1'>Transfer</A> Stopped", src)), stars("Chemicals Used"), t1, stars("Freezer status"), t2, src, src, src.c_used, src, src, d1, user)
		user << browse(dat, "window=freezer;size=400x500")
	else
		var/d1
		if (locate(/obj/item/weapon/flasks, src))
			var/counter = 1

			for(var/obj/item/weapon/flasks/F in src)
				d1 += text("<A href = '?src=\ref[];flask=[]'><B>Flask []</B></A>: [] / [] / []<BR>", src, counter, counter, F.oxygen, F.plasma, F.coolant)
				counter++
			d1 += "Key:    Oxygen / Plasma / Coolant<BR>"
		else
			d1 = "<B>No flasks!</B>"
		var/t1 = null
		switch(src.t_flags)
			if(0.0)
				t1 = text("<A href = '?src=\ref[];oxygen=1'>Oxygen-No</A> <A href = '?src=\ref[];plasma=1'>Plasma-No</A>", src, src)
			if(1.0)
				t1 = text("<A href = '?src=\ref[];oxygen=0'>Oxygen-Yes</A> <A href = '?src=\ref[];plasma=1'>Plasma-No</A>", src, src)
			if(2.0)
				t1 = text("<A href = '?src=\ref[];oxygen=1'>Oxygen-No</A> <A href = '?src=\ref[];plasma=0'>Plasma-Yes</A>", src, src)
			if(3.0)
				t1 = text("<A href = '?src=\ref[];oxygen=0'>Oxygen-Yes</A> <A href = '?src=\ref[];plasma=0'>Plasma-Yes</A>", src, src)
			else
		var/t2 = null
		if (src.status)
			t2 = text("Cooling-[] <A href = '?src=\ref[];cool=0'>Stop</A>", src.c_used, src)
		else
			t2 = text("<A href = '?src=\ref[];cool=1'>Cool</A> Stopped", src)
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><BR>\n\t\t<B>Temperature</B>: []<BR>\n\t\t<B>Transfer Status</B>: []<BR>\n\t\t   <B>Chemicals Used</B>: []<BR>\n\t\t<B>Freezer status</B>: []<BR>\n\t\t   <A href='?src=\ref[];cp=-5'>-</A> <A href='?src=\ref[];cp=-1'>-</A> [] <A href='?src=\ref[];cp=1'>+</A> <A href='?src=\ref[];cp=5'>+</A><BR>\n<BR>\n\t[]<BR>\n<BR>\n<BR>\n\t<A href='?src=\ref[];mach_close=freezer'>Close</A><BR>\n\t</TT></BODY></HTML>", src.temperature-T0C, (src.transfer ? text("Transfering <A href='?src=\ref[];transfer=0'>Stop</A>", src) : text("<A href='?src=\ref[];transfer=1'>Transfer</A> Stopped", src)), t1, t2, src, src, src.c_used, src, src, d1, user)
		user << browse(dat, "window=freezer;size=400x500")
	return

/obj/machinery/freezer/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["cp"])
			var/cp = text2num(href_list["cp"])
			src.c_used += cp
			src.c_used = min(max(round(src.c_used), 0), 10)
		if (href_list["oxygen"])
			var/t1 = text2num(href_list["oxygen"])
			if (t1)
				src.t_flags |= 1
			else
				src.t_flags &= 65534
		if (href_list["plasma"])
			var/t1 = text2num(href_list["plasma"])
			if (t1)
				src.t_flags |= 2
			else
				src.t_flags &= 65533
		if (href_list["cool"])
			src.status = text2num(href_list["cool"])
			src.icon_state = text("freezer_[]", src.status)
		if (href_list["transfer"])
			src.transfer = text2num(href_list["transfer"])
		if (href_list["flask"])
			var/t1 = text2num(href_list["flask"])
			if (t1 <= src.contents.len)
				var/obj/F = src.contents[t1]
				F.loc = src.loc
				src.rebuild_overlay()
	src.add_fingerprint(usr)
	return

/obj/machinery/freezer/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "freezer_0"
	else
		src.icon_state = "freezer_[status]"

/obj/machinery/freezer/process()
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(50)

	var/obj/item/weapon/flasks/F1
	var/obj/item/weapon/flasks/F2
	var/obj/item/weapon/flasks/F3
	if (src.contents.len >= 3)
		F3 = src.contents[3]
	if (src.contents.len >= 2)
		F2 = src.contents[2]
	if (src.contents.len >= 1)
		F1 = src.contents[1]
	var/u_cool = 0
	if (src.status)
		u_cool = src.c_used
		if ((F2 && F2.coolant))
			if (F2.coolant >= u_cool)
				F2.coolant -= u_cool
			else
				u_cool = F2.coolant
				F2.coolant = 0
		else
			if ((F1 && F1.coolant))
				if (F1.coolant >= u_cool)
					F1.coolant -= u_cool
				else
					u_cool = F1.coolant
					F1.coolant = 0
			else
				if ((F3 && F3.coolant))
					if (F3.coolant >= u_cool)
						F3.coolant -= u_cool
					else
						u_cool = F3.coolant
						F3.coolant = 0
				else
					u_cool = 0
	if (u_cool)
		src.temperature = max((-100.0+T0C), src.temperature - (u_cool * 5) )
		use_power(200)

	src.temperature = min(src.temperature + 5, 20+T0C)
	if (src.transfer)
		var/u_oxy = 0
		var/u_pla = 0
		if (src.t_flags & 1)
			u_oxy = 1
			if ((F1 && F1.oxygen))
				if (F1.oxygen >= u_oxy)
					F1.oxygen -= u_oxy
				else
					u_oxy = F1.oxygen
					F1.oxygen = 0
			else
				if ((F2 && F2.oxygen))
					if (F2.oxygen >= u_oxy)
						F2.oxygen -= u_oxy
					else
						u_oxy = F2.oxygen
						F2.oxygen = 0
				else
					if ((F3 && F3.oxygen))
						if (F3.oxygen >= u_oxy)
							F3.oxygen -= u_oxy
						else
							u_oxy = F3.oxygen
							F3.oxygen = 0
					else
						u_oxy = 0
		if (src.t_flags & 2)
			u_pla = 1
			if ((F3 && F3.plasma))
				if (F3.plasma >= u_pla)
					F3.plasma -= u_pla
				else
					u_pla = F3.plasma
					F3.plasma = 0
			else
				if ((F2 && F2.plasma))
					if (F2.plasma >= u_pla)
						F2.plasma -= u_pla
					else
						u_pla = F2.plasma
						F2.plasma = 0
				else
					if ((F1 && F1.plasma))
						if (F1.plasma >= u_pla)
							F1.plasma -= u_pla
						else
							u_pla = F1.plasma
							F1.plasma = 0
					else
						u_pla = 0
			if ( (u_oxy + u_pla) > 0)
				ngas.oxygen += u_oxy
				ngas.plasma += u_pla
				if(ngas.temperature < -100.0+T0C)
					ngas.temperature = -100.0+T0C
				ngas.temperature = src.temperature

	if (ngas.oxygen!=0 || ngas.plasma!=0)
		spawn( 1 )
			if (src.line_out)

				if(vnode)
					var/delta_gt = vsc.FLOWFRAC * ( vnode.get_gas_val(src) - gas.tot_gas() / capmult)
					calc_delta( src, gas, ngas, vnode, delta_gt)
				else
					leak_to_turf()
			return
	src.updateUsrDialog()

/obj/machinery/freezer/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/freezer/proc/leak_to_turf()
	var/turf/T = get_step(src, EAST)

	if(T.density)
		T = src.loc
		if(T.density)
			return

	flow_to_turf(gas, ngas, T)

/obj/machinery/freezer/orient_pipe(P as obj)
	if (!src.line_out)
		src.line_out = P
	else
		return 0
	return 1

/obj/machinery/freezer/New()
	..()
	var/obj/overlay/O1 = new /obj/overlay(  )
	O1.icon = 'Cryogenic2.dmi'
	O1.icon_state = "canister connector_0"
	O1.pixel_y = -16.0
	src.overlays += O1
	src.connector = O1
	new /obj/item/weapon/flasks/oxygen( src )
	new /obj/item/weapon/flasks/coolant( src )
	new /obj/item/weapon/flasks/plasma( src )
	rebuild_overlay()

	gas = new/obj/substance/gas()
	ngas = new/obj/substance/gas()

	gasflowlist += src
	return

/obj/machinery/freezer/buildnodes()
	var/turf/T = src.loc

	line_out = get_machine(level, T, p_dir )

	if(line_out) vnode = line_out.getline()
	return

/obj/machinery/freezer/get_gas_val(from)
	return gas.tot_gas()

/obj/machinery/freezer/get_gas(from)
	return gas

/obj/machinery/freezer/attackby(obj/item/weapon/flasks/F as obj, mob/user as mob)
	if (!( istype(F, /obj/item/weapon/flasks) ))
		return
	if (src.contents.len >= 3)
		user << "\blue All slots are full!"
		return
	else
		user.drop_item()
		F.loc = src
		src.rebuild_overlay()
	return

/obj/machinery/freezer/proc/rebuild_overlay()
	src.overlays = null
	src.overlays += src.connector
	var/counter = 0
	for(var/obj/item/weapon/flasks/F in src.contents)
		var/obj/overlay/O = new /obj/overlay(  )
		O.icon = F.icon
		O.icon_state = F.icon_state
		O.pixel_y = -17.0
		O.pixel_x = counter * 12
		src.overlays += O
		counter++
		if(counter>3)	break
	return
