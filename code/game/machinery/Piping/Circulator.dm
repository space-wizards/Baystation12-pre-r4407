// ***** circulator

/obj/machinery/circulator/New()
	..()
	gas1 = new/obj/substance/gas(src)
	gas1.maximum = capacity
	gas2 = new/obj/substance/gas(src)
	gas2.maximum = capacity

	ngas1 = new/obj/substance/gas()
	ngas2 = new/obj/substance/gas()

	gasflowlist += src

	//gas.co2 = capacity

	updateicon()

/obj/machinery/circulator/buildnodes()

	var/turf/TS = get_step(src, SOUTH)
	var/turf/TN = get_step(src, NORTH)

	for(var/obj/machinery/M in TS)

		if(M && (M.p_dir & 1))
			node1 = M
			break

	for(var/obj/machinery/M in TN)

		if(M && (M.p_dir & 2))
			node2 = M
			break


	if(node1) vnode1 = node1.getline()

	if(node2) vnode2 = node2.getline()


/obj/machinery/circulator/proc/control(var/on, var/prate)

	rate = prate/100*capacity

	if(status == 1)
		if(!on)
			status = 3
			spawn(30)
				if(status == 3)
					status = 0
					updateicon()
	else if(status == 0)
		if(on)
			status = (rate > 50 ? 1 : 2)
	else
		if(on)
			status = (rate > 50 ? 1 : 2)

	updateicon()


/obj/machinery/circulator/updateicon()

	if(stat & NOPOWER)
		icon_state = "circ[side]-p"
		return

	var/is
	switch(status)
		if(0)
			is = "off"
		if(1)
			is = "run"
		if(2)
			is = "slow"
		if(3)
			is = "slow"

	icon_state = "circ[side]-[is]"



/obj/machinery/circulator/power_change()
	..()
	updateicon()

/obj/machinery/circulator/gas_flow()

	gas1.replace_by(ngas1)
	gas2.replace_by(ngas2)

/obj/machinery/circulator/process()

	// if operating, pump from resv1 to resv2

	if(! (stat & NOPOWER) )				// only do circulator step if powered; still do rest of gas flow at all times
		if(status==1 || status==2)
			gas2.transfer_from(gas1, status==1? rate : rate/2)
			use_power(rate/capacity * 100)
		ngas1.replace_by(gas1)
		ngas2.replace_by(gas2)


	// now do standard process

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


/obj/machinery/circulator/proc/leak_to_turf(var/port)

	var/turf/T

	switch(port)
		if(1)
			T = get_step(src, SOUTH)
		if(2)
			T = get_step(src, NORTH)

	if(T.density)
		T = src.loc
		if(T.density)
			return

	switch(port)
		if(1)
			flow_to_turf(gas1, ngas1, T)
		if(2)
			flow_to_turf(gas2, ngas2, T)


	// do leak



/obj/machinery/circulator/get_gas_val(from)
	if(from == vnode1)
		return gas1.tot_gas()/capmult
	else
		return gas2.tot_gas()/capmult


/obj/machinery/circulator/get_gas(from)
	if(from == vnode1)
		return gas1
	else
		return gas2
