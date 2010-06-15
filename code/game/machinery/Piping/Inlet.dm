// inlet - equilibrates between pipe contents and turf
// very similar to vent, except that a vent always dumps pipe gas into turf
/obj/machinery/inlet/New()

	..()

	gas = new/obj/substance/gas(src)
	gas.maximum = capacity
	ngas = new/obj/substance/gas()
	gasflowlist += src

/obj/machinery/inlet/buildnodes()

	var/turf/T = get_step_3d(src.loc, src.dir)
	var/fdir = reverse_dir_3d(src.p_dir)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()

	return


/obj/machinery/inlet/get_gas_val(from)
	return gas.tot_gas()/2

/obj/machinery/inlet/get_gas(from)
	return gas


/obj/machinery/inlet/gas_flow()

	var/dbg = (suffix=="d") && Debug
	if(dbg) world.log << "I[tag]F1: [gas.tot_gas()] ~ [ngas.tot_gas()]"
	gas.replace_by(ngas)
	if(dbg) world.log << "I[tag]F2: [gas.tot_gas()] ~ [ngas.tot_gas()]"

/obj/machinery/inlet/process()


	var/dbg = (suffix=="d") && Debug
	if(dbg)	world.log << "I[tag]T1: [gas.tot_gas()] ~ [ngas.tot_gas()]"
	var/delta_gt

	var/turf/T = src.loc

	// this is the difference between vent and inlet

	if(T && !T.density)
		flow_to_turf(gas, ngas, T, dbg)		// act as gas leak

	if(dbg)	world.log << "I[tag]T2: [gas.tot_gas()] ~ [ngas.tot_gas()]"

	if(vnode)

		delta_gt = vsc.FLOWFRAC * ( vnode.get_gas_val(src) - gas.tot_gas() / capmult)

		calc_delta( src, gas, ngas, vnode, delta_gt)//, dbg)

	else
		leak_to_turf()



/obj/machinery/inlet/proc/leak_to_turf()
// note this is a leak from the node, not the inlet itself
// thus acts as a link between the inlet turf and the turf in step(dir)

	var/turf/T = get_step_3d(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)



