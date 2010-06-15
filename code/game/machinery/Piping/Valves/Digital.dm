// Digital Valve

/obj/machinery/valve/dvalve/New()
	..()
	gas1 = new/obj/substance/gas(src)
	ngas1 = new/obj/substance/gas()
	gas2 = new/obj/substance/gas(src)
	ngas2 = new/obj/substance/gas()

	gasflowlist += src

	//See comment in /mvalve/New()
/*	switch(dir)
		if(1, 2)
			p_dir = 3
		if(4,8)
			p_dir = 12*/

	icon_state = "dvalve[open]"

/obj/machinery/valve/dvalve/examine()
	set src in oview(1)
	if(NOPOWER)
		usr << "[desc] It is unpowered! It is [ open? "open" : "closed"]."
		return
	usr << "[desc] It is [ open? "open" : "closed"]."



/obj/machinery/valve/dvalve/buildnodes()
	var/turf/T = src.loc

	node1 = get_machine(level, T, dir )		// the h/e pipe

	node2 = get_machine(level, T ,reverse_dir_3d(dir))	// the regular pipe

	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()

	return


/obj/machinery/valve/dvalve/gas_flow()
	gas1.replace_by(ngas1)
	gas2.replace_by(ngas2)

/obj/machinery/valve/dvalve/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "dvalve[open]nopower"
		return
	icon_state = "dvalve[open]"


/obj/machinery/valve/dvalve/process()
	var/delta_gt

	if(vnode1)
		delta_gt = vsc.FLOWFRAC * ( vnode1.get_gas_val(src) - gas1.tot_gas() / capmult)
		calc_delta( src, gas1, ngas1, vnode1, delta_gt)

	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = vsc.FLOWFRAC * ( vnode2.get_gas_val(src) - gas2.tot_gas() / capmult)
		calc_delta( src, gas2, ngas2, vnode2, delta_gt)

	else
		leak_to_turf(2)


	if(open)		// valve operating, so transfer btwen resv1 & 2

		delta_gt = vsc.FLOWFRAC * (gas1.tot_gas() / capmult - gas2.tot_gas() / capmult)

		var/obj/substance/gas/ndelta = new()

		if(delta_gt < 0)		// then flowing from R2 to R1

			ndelta.set_frac(gas2, -delta_gt)

			ngas2.sub_delta(ndelta)
			ngas1.add_delta(ndelta)

		else				// flowing from R1 to R2
			ndelta.set_frac(gas1, delta_gt)
			ngas2.add_delta(ndelta)
			ngas1.sub_delta(ndelta)




/obj/machinery/valve/dvalve/get_gas_val(from)
	if(from == vnode2)
		return gas2.tot_gas()/capmult
	else
		return gas1.tot_gas()/capmult

/obj/machinery/valve/dvalve/get_gas(from)
	if(from == vnode2)
		return gas2
	return gas1

/obj/machinery/valve/dvalve/proc/leak_to_turf(var/port)

	var/turf/T


	switch(port)
		if(1)
			T = get_step_3d(src, dir)
		if(2)
			T = get_step_3d(src,reverse_dir_3d(dir))

	if(T.density)
		T = src.loc
		if(T.density)
			return

	if(port==1)
		flow_to_turf(gas1, ngas1, T)
	else
		flow_to_turf(gas2, ngas2, T)

/obj/machinery/valve/dvalve/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/valve/dvalve/attack_ai(var/mob/user as mob)
	if(istype(user,/mob/ai))
		var/mob/ai/AI = user
		var/password = accesspasswords["[password_digitalvalve]"]
		AI.sendcommand("[password] TOGGLE",src)

/obj/machinery/valve/dvalve/attack_hand(mob/user)
	..()
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return

	if(!open)		// now opening
		flick("dvalve01", src)
		icon_state = "dvalve1"
		sleep(10)
	else			// now closing
		flick("dvalve10", src)
		icon_state = "dvalve0"
		sleep(10)
	open = !open


/obj/machinery/valve/dvalve/receivemessage(message,sender)
	if(..())
		return
	var/list/listofcommand = getcommandlist(message)
	if(listofcommand.len < 2)
		return
	if(check_password(listofcommand[1]))
		if(listofcommand[2] == "TOGGLE")
			spawn(0)
				if(!open)		// now opening
					flick("dvalve01", src)
					icon_state = "dvalve1"
					sleep(10)
				else			// now closing
					flick("dvalve10", src)
					icon_state = "dvalve0"
					sleep(10)
				open = !open

		else if(listofcommand[2] == "RELEASE")

			if(!open)
				spawn(0)
					flick("dvalve01", src)
					icon_state = "dvalve1"
					sleep(10)
					open = !open

		else if(listofcommand[2] == "PASS")
			if(open)
				spawn(0)
					flick("dvalve10", src)
					icon_state = "dvalve0"
					sleep(10)
					open = !open


