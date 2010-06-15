// Filter inlet
// works with filter_control

/obj/machinery/inlet/filter/New()
	..()
	src.gas = new /obj/substance/gas( src )
	src.gas.maximum = src.capacity
	src.ngas = new /obj/substance/gas()

/obj/machinery/inlet/filter/buildnodes()
	var/turf/T = get_step_3d(src.loc, src.dir)
	var/fdir = reverse_dir_3d(src.p_dir)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()
	return

/obj/machinery/inlet/filter/get_gas_val(from)
	return gas.tot_gas()/2

/obj/machinery/inlet/filter/get_gas(from)
	return gas

/obj/machinery/inlet/filter/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/inlet/filter/process()
	..()

	src.updateicon()

	if(stat & (NOPOWER|BROKEN))
		return

	var/turf/T = src.loc
	if(!T || T.density)	return

	if(!vnode)	return leak_to_turf()
	var/obj/substance/gas/exterior = new()

	exterior.oxygen = T.oxygen()
	exterior.n2 = T.n2()
	exterior.plasma = T.poison()
	exterior.co2 = T.co2()
	exterior.sl_gas = T.sl_gas()
	exterior.temperature = T.temp()


	var/obj/substance/gas/flowing = new()

	var/flow_rate = (exterior.tot_gas()-gas.tot_gas())*vsc.FLOWFRAC

	if(flow_rate <= 0)
		return

	flowing.set_frac(exterior,flow_rate)

	if(!(f_mask & GAS_O2))	flowing.oxygen	= 0
	if(!(f_mask & GAS_N2))	flowing.n2		= 0
	if(!(f_mask & GAS_PL))	flowing.plasma	= 0
	if(!(f_mask & GAS_CO2))	flowing.co2		= 0
	if(!(f_mask & GAS_N2O))	flowing.sl_gas	= 0

	use_power(5,ENVIRON)

	exterior.sub_delta(flowing)
	gas.add_delta(flowing)

	return

/obj/machinery/inlet/filter/leak_to_turf()
// note this is a leak from the node, not the inlet itself
// thus acts as a link between the inlet turf and the turf in step(dir)
	var/turf/T = get_step_3d(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)

/obj/machinery/inlet/filter/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	spawn(rand(1,15))
		updateicon()
	return

/obj/machinery/inlet/filter/updateicon()
	if(stat & NOPOWER)
		icon_state = "inlet_filter-0"
		return
	if(src.gas.tot_gas() > src.gas.maximum/2)
		icon_state = "inlet_filter-4"
	else if(src.gas.tot_gas() > src.gas.maximum/3)
		icon_state = "inlet_filter-3"
	else if(src.gas.tot_gas() > src.gas.maximum/4)
		icon_state = "inlet_filter-2"
	else if(src.gas.tot_gas() >= 1 || src.f_mask >= 1)
		icon_state = "inlet_filter-1"
	else
		icon_state = "inlet_filter-0"
	return

