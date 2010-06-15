
/obj/machinery/oneway/pipepump/process()
	if(! (stat & NOPOWER) )  // pump if power
		gas1.transfer_from(gas2, rate)
		use_power(25, ENVIRON)
		ngas1.replace_by(gas1)
		ngas2.replace_by(gas2)

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

/obj/machinery/oneway/pipepump/updateicon()
	icon_state = "pipepump-[(stat & NOPOWER) ? "stop" : "run"]"

/obj/machinery/oneway/pipepump/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else

		stat |= NOPOWER
	spawn(rand(1,15))	// So they don't all turn off at the same time
		updateicon()
