/obj/machinery/connector/New()
	..()

	gas = new/obj/substance/gas(src)
	gas.maximum = capacity
	ngas = new/obj/substance/gas()

	gasflowlist += src
	spawn(5)
		var/obj/machinery/atmoalter/A = locate(/obj/machinery/atmoalter, src.loc)

		if(A && A.c_status != 0)
			connected = A
			A.anchored = 1

/obj/machinery/connector/buildnodes()
	var/turf/T = get_step_3d(src.loc, src.dir)
	var/fdir = reverse_dir_3d(src.p_dir)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node)
		vnode = node.getline()
	return

/obj/machinery/connector/examine()
	set src in oview(1)
	..()
	if(connected)
		usr << "It is connected to \an [connected.name]."
	else
		usr << "It is unconnected."

/obj/machinery/connector/get_gas_val(from)
	return gas.tot_gas()/capmult

/obj/machinery/connector/get_gas(from)
	return gas


/obj/machinery/connector/gas_flow()
	gas.replace_by(ngas)
	flag = 0

/obj/machinery/connector/process()

	var/delta_gt

	if(vnode)

		delta_gt = vsc.FLOWFRAC * ( vnode.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode, delta_gt)//, dbg)

	else
		leak_to_turf()

	if(connected)
		var/amount
		if(connected.c_status == 1)				// canister set to release
			amount = min(connected.c_per, capacity - gas.tot_gas() )	// limit to space in connector
			amount = max(0, min(amount, connected.gas.tot_gas() ) )		// limit to amount in canister, or 0
			ngas.transfer_from( connected.gas, amount)
		else if(connected.c_status == 2)		// canister set to accept

			amount = min(connected.c_per, connected.gas.maximum - connected.gas.tot_gas())	//limit to space in canister
			amount = max(0, min(amount, gas.tot_gas() ) )				// limit to amount in connector, or 0

			connected.gas.transfer_from( ngas, amount)


/obj/machinery/connector/proc/leak_to_turf()
	var/turf/T = get_step_3d(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)

