/obj/machinery/junction/New()
	..()
	gas = new/obj/substance/gas(src)
	ngas = new/obj/substance/gas()
	gasflowlist += src

/obj/machinery/junction/buildnodes()

	var/turf/T = src.loc

	node1 = get_he_machine(level, T, h_dir )		// the h/e pipe

	node2 = get_machine(level, T , p_dir )	// the regular pipe

	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()

	return


/obj/machinery/junction/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/junction/process()

	var/delta_gt

	if(vnode1)
		delta_gt = vsc.FLOWFRAC * ( vnode1.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode1, delta_gt)
	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = vsc.FLOWFRAC * ( vnode2.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode2, delta_gt)
	else
		leak_to_turf(2)


/obj/machinery/junction/get_gas_val(from)
	return gas.tot_gas()/capmult

/obj/machinery/junction/get_gas(from)
	return gas

/obj/machinery/junction/proc/leak_to_turf(var/port)

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

	flow_to_turf(gas, ngas, T)