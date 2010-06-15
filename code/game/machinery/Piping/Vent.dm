/obj/machinery/vent/New()

	..()
	gas = new/obj/substance/gas(src)
	gas.maximum = capacity
	ngas = new/obj/substance/gas()
	gasflowlist += src


/obj/machinery/vent/buildnodes()

	var/turf/T = get_step_3d(src.loc, src.dir)
	var/fdir = reverse_dir_3d(src.p_dir)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()

	return


/obj/machinery/vent/get_gas_val(from)
	return gas.tot_gas()/2

/obj/machinery/vent/get_gas(from)
	return gas


/obj/machinery/vent/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/vent/process()
	var/delta_gt

	var/turf/T = src.loc

	delta_gt = vsc.FLOWFRAC * (gas.tot_gas() / capmult)
	ngas.turf_add(T, delta_gt)

	if(vnode)
		delta_gt = vsc.FLOWFRAC * ( vnode.get_gas_val(src) - gas.tot_gas() / capmult)
		calc_delta( src, gas, ngas, vnode, delta_gt)
	else
		leak_to_turf()

/obj/machinery/vent/proc/leak_to_turf()
	var/turf/T = get_step_3d(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)


