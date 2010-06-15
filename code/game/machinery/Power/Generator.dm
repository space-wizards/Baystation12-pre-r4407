//THE TEG
/obj/machinery/power/generator/New()
	..()

	spawn(5)
		circ1 = locate(/obj/machinery/circulator) in get_step(src,WEST)
		circ2 = locate(/obj/machinery/circulator) in get_step(src,EAST)
		if(!circ1 || !circ2)
			circ1 = locate(/obj/a_pipe/divider/a_circulator) in get_step(src,WEST)
			circ2 = locate(/obj/a_pipe/divider/a_circulator) in get_step(src,EAST)
			if(!circ1 || !circ2)
				stat |= BROKEN

		updateicon()

/obj/machinery/power/generator/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays = null
	else
		overlays = null

		overlays += image('power.dmi', "teg-oc[c1on][c2on]")

		if(lastgenlev != 0)
			overlays += image('power.dmi', "teg-op[lastgenlev]")

#define GENRATE 0.0017			// generator output coefficient from Q

/obj/machinery/power/generator/process()

	if(istype(circ1,/obj/a_pipe/divider/a_circulator)) //Do a_pipe calcs, which use different gas references.
		var/obj/a_pipe/divider/a_circulator
			a_circ1 = circ1
			a_circ2 = circ2
		if(!a_circ1.connect)
			stat |= BROKEN
			return
		if(!a_circ2.connect)
			stat |= BROKEN
			return
		var/gc = a_circ1.connect.gas.shc()
		var/gh = a_circ2.connect.gas.shc()

		var
			tc = a_circ1.connect.gas.temperature
			th = a_circ2.connect.gas.temperature
			deltat = th-tc

			eta = (1-tc/th)*0.65

		if(gc > 0 && deltat > 0)
			var
				ghoc = gh/gc
				fdt = 1/((1-eta)*ghoc+1)

			fdt = min(fdt,0.1)

			var
				q = fdt*eta*gh*deltat

				thp = th-fdt*deltat
				tcp = tc+fdt*(1-eta)*ghoc*deltat

			lastgen = q*GENRATE
			add_avail(lastgen)

			a_circ1.connect.gas.temperature = tcp
			a_circ2.connect.gas.temperature = thp
		else
			lastgen = 0

		var/genlev = max(0, min( round(11*lastgen / 100000), 11))
		if(genlev != lastgenlev)
			lastgenlev = genlev
			updateicon()

		src.updateDialog()

		return

	if(circ1 && circ2)


		var/gc = circ1.gas2.shc()
		var/gh = circ2.gas2.shc()

		var/tc = circ1.gas2.temperature
		var/th = circ2.gas2.temperature
		var/deltat = th-tc

		var/eta = (1-tc/th)*0.65		// efficiency 65% of Carnot

		if(gc > 0 && deltat >0)		// require some cold gas (for sink) and a positive temp gradient
			var/ghoc = gh/gc

			//var/qc = gc*tc
			//var/qh = gh*th

			var/fdt = 1/( (1-eta)*ghoc + 1)	// min timestep

			fdt = min(fdt, 0.1)	// max timestep

			var/q = fdt*eta*gh*(deltat)	// heat generated

			var/thp = th - fdt * deltat
			var/tcp = tc + fdt * (1 - eta) * (ghoc) * deltat

			lastgen = q * GENRATE
			add_avail(lastgen)

			circ1.ngas2.temperature = tcp
			circ2.ngas2.temperature = thp

		else
			lastgen = 0





		// update icon overlays only if displayed level has changed

		var/genlev = max(0, min( round(11*lastgen / 100000), 11))
		if(genlev != lastgenlev)
			lastgenlev = genlev
			updateicon()

		src.updateDialog()

/obj/machinery/power/generator/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/power/generator/attack_hand(mob/user)

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/power/generator/proc/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) && (!istype(user, /mob/ai)))
		user.machine = null
		user << browse(null, "window=teg")
		return

	user.machine = src

	if(istype(circ1,/obj/a_pipe/divider/a_circulator))
		var/obj/a_pipe/divider/a_circulator
			a_circ1 = circ1
			a_circ2 = circ2
		var/t = "<PRE><B>Thermo-Electric Generator</B><HR>"

		t += "Output : [round(lastgen)] W<BR><BR>"

		t += "<B>Cold loop</B><BR>"
		t += "Temperature Inlet: [round(a_circ1.p_zone.gas.temperature, 0.1)] K  Outlet: [round(a_circ1.connect.gas.temperature, 0.1)] K<BR>"

		t += "Circulator: [c1on ? "<B>On</B> <A href = '?src=\ref[src];c1p=1'>Off</A>" : "<A href = '?src=\ref[src];c1p=1'>On</A> <B>Off</B> "]<BR>"
		t += "Rate: <A href = '?src=\ref[src];c1r=-3'>M</A> <A href = '?src=\ref[src];c1r=-2'>-</A> <A href = '?src=\ref[src];c1r=-1'>-</A> [add_lspace(c1rate,3)]% <A href = '?src=\ref[src];c1r=1'>+</A> <A href = '?src=\ref[src];c1r=2'>+</A> <A href = '?src=\ref[src];c1r=3'>M</A><BR>"

		t += "<B>Hot loop</B><BR>"
		t += "Temperature Inlet: [round(a_circ2.p_zone.gas.temperature, 0.1)] K  Outlet: [round(a_circ2.connect.gas.temperature, 0.1)] K<BR>"

		t += "Circulator: [c2on ? "<B>On</B> <A href = '?src=\ref[src];c2p=1'>Off</A>" : "<A href = '?src=\ref[src];c2p=1'>On</A> <B>Off</B> "]<BR>"
		t += "Rate: <A href = '?src=\ref[src];c2r=-3'>M</A> <A href = '?src=\ref[src];c2r=-2'>-</A> <A href = '?src=\ref[src];c2r=-1'>-</A> [add_lspace(c2rate,3)]% <A href = '?src=\ref[src];c2r=1'>+</A> <A href = '?src=\ref[src];c2r=2'>+</A> <A href = '?src=\ref[src];c2r=3'>M</A><BR>"

		t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

		t += "</PRE>"
		user << browse(t, "window=teg;size=460x300")

	else

		var/t = "<PRE><B>Thermo-Electric Generator</B><HR>"

		t += "Output : [round(lastgen)] W<BR><BR>"

		t += "<B>Cold loop</B><BR>"
		t += "Temperature Inlet: [round(circ1.ngas1.temperature, 0.1)] K  Outlet: [round(circ1.ngas2.temperature, 0.1)] K<BR>"

		t += "Circulator: [c1on ? "<B>On</B> <A href = '?src=\ref[src];c1p=1'>Off</A>" : "<A href = '?src=\ref[src];c1p=1'>On</A> <B>Off</B> "]<BR>"
		t += "Rate: <A href = '?src=\ref[src];c1r=-3'>M</A> <A href = '?src=\ref[src];c1r=-2'>-</A> <A href = '?src=\ref[src];c1r=-1'>-</A> [add_lspace(c1rate,3)]% <A href = '?src=\ref[src];c1r=1'>+</A> <A href = '?src=\ref[src];c1r=2'>+</A> <A href = '?src=\ref[src];c1r=3'>M</A><BR>"

		t += "<B>Hot loop</B><BR>"
		t += "Temperature Inlet: [round(circ2.ngas1.temperature, 0.1)] K  Outlet: [round(circ2.ngas2.temperature, 0.1)] K<BR>"

		t += "Circulator: [c2on ? "<B>On</B> <A href = '?src=\ref[src];c2p=1'>Off</A>" : "<A href = '?src=\ref[src];c2p=1'>On</A> <B>Off</B> "]<BR>"
		t += "Rate: <A href = '?src=\ref[src];c2r=-3'>M</A> <A href = '?src=\ref[src];c2r=-2'>-</A> <A href = '?src=\ref[src];c2r=-1'>-</A> [add_lspace(c2rate,3)]% <A href = '?src=\ref[src];c2r=1'>+</A> <A href = '?src=\ref[src];c2r=2'>+</A> <A href = '?src=\ref[src];c2r=3'>M</A><BR>"

		t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

		t += "</PRE>"
		user << browse(t, "window=teg;size=460x300")
	return

/obj/machinery/power/generator/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
			return

	//world << "[href] ; [href_list[href]]"

	if (( usr.machine==src && ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))


		if( href_list["close"] )
			usr << browse(null, "window=teg")
			usr.machine = null
			return

		else if( href_list["c1p"] )
			c1on = !c1on
			circ1.control(c1on, c1rate)
			updateicon()
		else if( href_list["c2p"] )
			c2on = !c2on
			circ2.control(c2on, c2rate)
			updateicon()

		else if( href_list["c1r"] )

			var/i = text2num(href_list["c1r"])

			var/d = 0
			switch(i)
				if(-3)
					c1rate = 0
				if(3)
					c1rate = 100

				if(1)
					d = 1
				if(-1)
					d = -1
				if(2)
					d = 10
				if(-2)
					d = -10

			c1rate += d
			c1rate = max(1, min(100, c1rate))	// clamp to range

			circ1.control(c1on, c1rate)
			updateicon()

		else if( href_list["c2r"] )

			var/i = text2num(href_list["c2r"])

			var/d = 0
			switch(i)
				if(-3)
					c2rate = 0
				if(3)
					c2rate = 100

				if(1)
					d = 1
				if(-1)
					d = -1
				if(2)
					d = 10
				if(-2)
					d = -10

			c2rate += d
			c2rate = max(1, min(100, c2rate))	// clamp to range

			circ2.control(c2on, c2rate)
			updateicon()

		src.updateUsrDialog()

	else
		usr << browse(null, "window=teg")
		usr.machine = null

	return

/obj/machinery/power/generator/power_change()
	..()
	updateicon()

