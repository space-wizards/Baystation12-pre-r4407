/obj/machinery/cryo_cell/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
				src.icon_state = "broken"
		else
	return

/obj/machinery/cryo_cell/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
			A.blob_act()
		src.icon_state = "broken"

/obj/machinery/cryo_cell/orient_pipe(P as obj)
	if (!src.line_in)
		src.line_in = P
	else
		return 0
	return 1

/obj/machinery/cryo_cell/allow_drop()
	return 0

/obj/machinery/cryo_cell/New()
	..()
	src.layer = 5
	O1 = new /obj/overlay(  )
	O1.icon = 'Cryogenic2.dmi'
	O1.icon_state = "cellconsole"
	O1.pixel_y = -32.0
	O1.layer = 4

	O2 = new /obj/overlay(  )
	O2.icon = 'Cryogenic2.dmi'
	O2.icon_state = "cellbottom"
	O2.pixel_y = -32.0
	src.pixel_y = 32

	add_overlays()

	src.gas = new /obj/substance/gas( null )
	gas.temperature = T20C
	src.ngas = new /obj/substance/gas (null)
	ngas.temperature = T20C

	gasflowlist += src

/obj/machinery/cryo_cell/proc/add_overlays()
	src.overlays = list(O1, O2)

/obj/machinery/cryo_cell/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "celltop-p"
		O1.icon_state="cellconsole-p"
		O2.icon_state="cellbottom-p"
	else
		icon_state = "celltop[ occupant ? "_1" : ""]"
		O1.icon_state ="cellconsole"
		O2.icon_state ="cellbottom"

	add_overlays()

/obj/machinery/cryo_cell/process()
	if(stat & NOPOWER)
		return
	if(vnode)
		var/delta_gt = vsc.FLOWFRAC * ( vnode.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode, delta_gt)
	else
		leak_to_turf()

	use_power(500)
	src.updateUsrDialog()
	return

/obj/machinery/cryo_cell/proc/leak_to_turf()
	var/turf/T = get_step(src, WEST)
	if(T.density)
		T = src.loc
		if(T.density)
			return
	flow_to_turf(gas, ngas, T)

/obj/machinery/cryo_cell/buildnodes()
	var/turf/T = src.loc
	line_in = get_machine(level, T, p_dir )
	if(line_in)
		vnode = line_in.getline()
	return

/obj/machinery/cryo_cell/get_gas_val(from)
	return gas.tot_gas()

/obj/machinery/cryo_cell/get_gas(from)
	return gas

/obj/machinery/cryo_cell/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/cryo_cell/verb/move_eject()
	set src in oview(1)
	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/cryo_cell/verb/move_inside()
	set src in oview(1)
	if (usr.stat != 0 || stat & (NOPOWER|BROKEN))
		return
	if (src.occupant)
		usr << "\blue <B>The cell is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "Subject may not have abiotic items on."
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "celltop_1"
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(usr)
	return

/obj/machinery/cryo_cell/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if (stat & (BROKEN|NOPOWER))
		return
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "\blue <B>The cell is already occupied!</B>"
		return
	if (G.affecting.abiotic())
		user << "Subject may not have abiotic items on."
		return
	var/mob/M = G.affecting
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "celltop_1"
	for(var/obj/O in src)
		del(O)
	src.add_fingerprint(user)
	del(G)
	return

/obj/machinery/cryo_cell/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/cryo_cell/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/cryo_cell/attack_hand(mob/user as mob)
	if(..())
		return
	user.machine = src
	if(istype(user, /mob/human) || istype(user, /mob/ai))
		var/dat = "<font color='blue'> <B>System Statistics:</B></FONT><BR>"
		if (src.gas.temperature > T0C)
			dat += text("<font color='red'>\tTemperature (&deg;C): [] (MUST be below 0, add coolant to mixture)</FONT><BR>", round(src.gas.temperature-T0C, 0.1))
		else
			dat += text("<font color='blue'>\tTemperature (&deg;C): [] </FONT><BR>", round(src.gas.temperature-T0C, 0.1))
		if (src.gas.plasma < 1)
			dat += text("<font color='red'>\tPlasma Units: [] (Add plasma to mixture!)</FONT><BR>", round(src.gas.plasma, 0.1))
		else
			dat += text("<font color='blue'>\tPlasma Units: []</FONT><BR>", round(src.gas.plasma, 0.1))
		if (src.gas.oxygen < 1)
			dat += text("<font color='red'>\tOxygen Units: [] (Add oxygen to mixture!)</FONT><BR>", round(src.gas.oxygen, 0.1))
		else
			dat += text("<font color='blue'>\tOxygen Units: []</FONT><BR>", round(src.gas.oxygen, 0.1))
		if (src.occupant)
			dat += text("<BR><font color='blue'><B>Occupant Statistics:</B></FONT><BR>")
			var/t1
			switch(src.occupant.stat)
				if(0.0)
					t1 = "Conscious"
				if(1.0)
					t1 = "Unconscious"
				if(2.0)
					t1 = "*dead*"
				else
			dat += text("[]\tHealth %: [] ([])</FONT><BR>", (src.occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.health, t1)
			dat += text("[]\t-Core Temperature: []&deg;C ([]&deg;F)</FONT><BR>", (src.occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.bodytemperature-T0C, src.occupant.bodytemperature*1.8-459.67)
			dat += text("[]\t-Brute Damage %: []</FONT><BR>", (src.occupant.bruteloss < 60 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.bruteloss)
			dat += text("[]\t-Respiratory Damage %: []</FONT><BR>", (src.occupant.oxyloss < 60 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.oxyloss)
			dat += text("[]\t-Toxin Content %: []</FONT><BR>", (src.occupant.toxloss < 60 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.toxloss)
			dat += text("[]\t-Burn Severity %: []</FONT>", (src.occupant.fireloss < 60 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.fireloss)
			if(istype(src.occupant, /mob/human))
				dat += text("<BR><font color='blue'><B>Detailed Occupant Statistics:</B></FONT><BR>")
				var/mob/human/H = src.occupant
				for(var/A in H.organs)
					var/obj/item/weapon/organ/external/current = H.organs[A]
					var/organstatus = 100
					if(current.get_damage())
						organstatus = 100*(current.get_damage()/current.max_damage)
					dat += text("[]\t-[]: []% (Brute: [] Fire: [])<BR>",(organstatus > 60 ? "<font color='blue'>" : "<font color='red'>"), capitalize(A), round(organstatus, 0.1), current.brute_dam, current.burn_dam)

		dat += text("<BR><BR><A href = '?src=\ref[];drain=1'>Drain Cryocell</A> <A href='?src=\ref[];mach_close=cryo'>Close</A>", user, user)
		user << browse(dat, "window=cryo;size=400x565")
	else
		var/dat = text("<font color='blue'> <B>[]</B></FONT><BR>", stars("System Statistics:"))
		if (src.gas.temperature > T0C)
			dat += text("<font color='red'>\t[]</FONT><BR>", stars(text("Temperature (C): [] (MUST be below 0, add coolant to mixture)", round(src.gas.temperature-T0C, 0.1))))
		else
			dat += text("<font color='blue'>\t[] </FONT><BR>", stars(text("Temperature(C): []", round(src.gas.temperature-T0C, 0.1))))
		if (src.gas.plasma < 1)
			dat += text("<font color='red'>\t[]</FONT><BR>", stars(text("Plasma Units: [] (Add plasma to mixture!)", round(src.gas.plasma, 0.1))))
		else
			dat += text("<font color='blue'>\t[]</FONT><BR>", stars(text("Plasma Units: []", round(src.gas.plasma, 0.1))))
		if (src.gas.oxygen < 1)
			dat += text("<font color='red'>\t[]</FONT><BR>", stars(text("Oxygen Units: [] (Add oxygen to mixture!)", round(src.gas.oxygen, 0.1))))
		else
			dat += text("<font color='blue'>\t[]</FONT><BR>", stars(text("Oxygen Units: []", round(src.gas.oxygen, 0.1))))
		if (src.occupant)
			dat += text("<BR><font color='blue'><B>[]:</B></FONT><BR>", stars("Occupant Statistics"))
			var/t1 = null
			switch(src.occupant.stat)
				if(0.0)
					t1 = "Conscious"
				if(1.0)
					t1 = "Unconscious"
				if(2.0)
					t1 = "*dead*"
				else
			dat += text("[]\t[]</FONT><BR>", (src.occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>"), stars(text("Health %: [] ([])", src.occupant.health, t1)))
			dat += text("[]\t[]</FONT><BR>", (src.occupant.bruteloss < 60 ? "<font color='blue'>" : "<font color='red'>"), stars(text("-Brute Damage %: []", src.occupant.bruteloss)))
			dat += text("[]\t[]</FONT><BR>", (src.occupant.oxyloss < 60 ? "<font color='blue'>" : "<font color='red'>"), stars(text("-Respiratory Damage %: []", src.occupant.oxyloss)))
			dat += text("[]\t[]</FONT><BR>", (src.occupant.toxloss < 60 ? "<font color='blue'>" : "<font color='red'>"), stars(text("-Toxin Content %: []", src.occupant.toxloss)))
			dat += text("[]\t[]</FONT>", (src.occupant.fireloss < 60 ? "<font color='blue'>" : "<font color='red'>"), stars(text("-Burn Severity %: []", src.occupant.fireloss)))
			if(istype(src.occupant, /mob/human))
				dat += text("<BR><font color='blue'><BR>[]:</B></FONT><BR>", stars("Detailed Occupant Statistics"))
				var/mob/human/H = src.occupant
				for(var/A in H.organs)
					var/obj/item/weapon/organ/external/current = H.organs[A]
					var/organstatus = 100
					if(current.get_damage())
						organstatus = 100*(current.max_damage/current.get_damage())
					dat += text("[]\t-[]: []% ([stars("Brute")]: [] [stars("Fire")]: [])<BR>",(organstatus > 60 ? "<font color='blue'>" : "<font color='red'>"), stars(capitalize(A)), round(organstatus, 0.1), current.brute_dam, current.burn_dam)
		dat += text("<BR><BR><A href = '?src=\ref[];drain=1'>Drain Cryocell</A> <A href='?src=\ref[];mach_close=cryo'>Close</A>", user, user)
		user << browse(dat, "window=cryo;size=400x565")
	return

/obj/machinery/cryo_cell/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["drain"])
			//leak_to_turf()
			if(vnode)
				//vnode:leak_to_turf()
				var/obj/machinery/freezer/target = vnode:vnode2
				if (target)
					//target.leak_to_turf()
					var/sendplasma = src.gas.plasma + vnode:gas:plasma + vnode:vnode2:gas:plasma
					var/sendoxygen = src.gas.oxygen + vnode:gas:oxygen + vnode:vnode2:gas:oxygen
					for (var/obj/item/weapon/flasks/flask in target.contents)
						if (istype(flask, /obj/item/weapon/flasks/plasma))
							flask.plasma += sendplasma
							src.gas.plasma = 0
							src.ngas.plasma = 0
							src.vnode:gas.plasma = 0
							src.vnode:ngas.plasma = 0
							src.vnode:vnode2:gas.plasma = 0
							src.vnode:vnode2:ngas.plasma = 0
						else if (istype(flask, /obj/item/weapon/flasks/oxygen))
							flask.oxygen += sendoxygen
							src.gas.oxygen = 0
							src.ngas.oxygen = 0
							src.vnode:gas.oxygen = 0
							src.vnode:ngas.oxygen = 0
							src.vnode:vnode2:gas.oxygen = 0
							src.vnode:vnode2:ngas.oxygen = 0
				//we ignore co2, sl_gas, and n2
			else
				leak_to_turf()
		src.add_fingerprint(usr)

	else
		usr << "User too far?"
	return

/obj/machinery/cryo_cell/proc/go_out()
	if(!( src.occupant ))
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "celltop"
	return

/obj/machinery/cryo_cell/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/cryo_cell/alter_health(mob/M as mob)
	if(stat & NOPOWER)
		return
	if(M.bodytemperature >= (-95.0+T0C))
		M.bodytemperature = M.adjustBodyTemp(M.bodytemperature, src.gas.temperature, 1.0)
	if(M.bodytemperature < (-95.0+T0C))
		M.bodytemperature = (-95.0+T0C)
	if (M.health < 0)
		if ((src.gas.temperature > T0C || src.gas.plasma < 1))
			return
	if (M.stat == 2)
		return
	if (src.gas.oxygen >= 1)
		src.ngas.oxygen--
		if (M.oxyloss >= 10)
			var/amount = max(0.15, 2)
			M.oxyloss -= amount
		else
			M.oxyloss = 0
		M.updatehealth()
	if ((src.gas.temperature < T0C && src.gas.plasma >= 1))
		src.ngas.plasma--
		if (M.toxloss > 5)
			var/amount = max(0.1, 2)
			M.toxloss -= amount
		else
			M.toxloss = 0
		M.updatehealth()
		if (istype(M, /mob/human))
			var/mob/human/H = M
			var/ok = 0
			for(var/organ in H.organs)
				var/obj/item/weapon/organ/external/affecting = H.organs[text("[]", organ)]
				ok += affecting.heal_damage(5, 5)
			if (ok)
				H.UpdateDamageIcon()
			else
				H.UpdateDamage()
		else
			if (M.fireloss > 15)
				var/amount = max(0.3, 2)
				M.fireloss -= amount
			else
				M.fireloss = 0
			if (M.bruteloss > 10)
				var/amount = max(0.3, 2)
				M.bruteloss -= amount
			else
				M.bruteloss = 0
		M.updatehealth()
		M.paralysis += 5
	if (src.gas.temperature < (60+T0C))
		src.gas.temperature = min(src.gas.temperature + 1, 60+T0C)
	src.updateUsrDialog()
	return
