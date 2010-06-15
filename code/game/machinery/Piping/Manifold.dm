// *** Manifold


/obj/machinery/manifold/New()
	..()

	//Once again, old code, prevents proper in-game spawning.
/*	switch(dir)
		if(NORTH)
			p_dir = 13 //NORTH|EAST|WEST

		if(SOUTH)
			p_dir = 14 //SOUTH|EAST|WEST

		if(EAST)
			p_dir = 7 //EAST|NORTH|SOUTH

		if(WEST)
			p_dir = 11 //WEST|NORTH|SOUTH
*/


	src.gas = new /obj/substance/gas( src )
	src.gas.maximum = src.capacity
	src.ngas = new /obj/substance/gas()
	gasflowlist += src


/obj/machinery/manifold/buildnodes()
	var/turf/T = src.loc

	node3 = get_machine( level, T, dir )		// the injector port

	n1dir = turn(dir, 90)
	n2dir = turn(dir,-90)

	node1 = get_machine( level, T , n1dir )	// the main flow dir


	node2 = get_machine( level, T , n2dir )


	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()
	if(node3) vnode3 = node3.getline()

	return


/obj/machinery/manifold/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/manifold/process()
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

	if(vnode3)
		delta_gt = vsc.FLOWFRAC * ( vnode3.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode3, delta_gt)
	else
		leak_to_turf(3)


/obj/machinery/manifold/get_gas_val(from)
	return gas.tot_gas()/capmult

/obj/machinery/manifold/get_gas(from)
	return gas

/obj/machinery/manifold/proc/leak_to_turf(var/port)
	var/turf/T

	switch(port)
		if(1)
			T = get_step_3d(src, n1dir)
		if(2)
			T = get_step_3d(src, n2dir)
		if(3)
			T = get_step_3d(src, dir)

	if(T.density)
		T = src.loc
		if(T.density)
			return

	flow_to_turf(gas, ngas, T)

	//	delta = 0
