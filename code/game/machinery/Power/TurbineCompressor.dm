// the inlet stage of the gas turbine electricity generator

/obj/machinery/compressor/New()
	..()

	gas = new/obj/substance/gas(src)
	gas.maximum = capacity
	inturf = get_step(src, WEST)

	spawn(5)
		turbine = locate() in get_step(src, EAST)
		if(!turbine)
			stat |= BROKEN


#define COMPFRICTION 5e5
#define COMPSTARTERLOAD 2800

/obj/machinery/compressor/process()

	overlays = null
	if(stat & BROKEN)
		return
	if(!turbine)
		stat |= BROKEN
		return
	rpm = 0.9* rpm + 0.1 * rpmtarget


	gas.turf_take(inturf, rpm/30000*capacity)


	rpm = max(0, rpm - (rpm*rpm)/COMPFRICTION)


	if(starter && !(stat & NOPOWER))
		use_power(2800)
		if(rpm<1000)
			rpmtarget = 1000
		else
			starter = 0
	else
		if(rpm<1000)
			rpmtarget = 0



	if(rpm>50000)
		overlays += image('pipes.dmi', "comp-o4", FLY_LAYER)
	else if(rpm>10000)
		overlays += image('pipes.dmi', "comp-o3", FLY_LAYER)
	else if(rpm>2000)
		overlays += image('pipes.dmi', "comp-o2", FLY_LAYER)
	else if(rpm>500)
		overlays += image('pipes.dmi', "comp-o1", FLY_LAYER)


