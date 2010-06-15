/obj/machinery/power/turbine/New()
	..()

	outturf = get_step(src, EAST)

	spawn(5)

		compressor = locate() in get_step(src, WEST)
		if(!compressor)
			stat |= BROKEN


#define TURBPRES 90000000
#define TURBGENQ 20000
#define TURBGENG 0.8

/obj/machinery/power/turbine/process()
	overlays = null
	if(stat & BROKEN)
		return
	if(!compressor)
		stat |= BROKEN
		return
	lastgen = ((compressor.rpm / TURBGENQ)**TURBGENG) *TURBGENQ

	add_avail(lastgen)

	//if(compressor.gas.temperature > (T20C+50))
	var/newrpm = ((compressor.gas.temperature-T20C-50) * compressor.gas.tot_gas() / TURBPRES)*30000
	newrpm = max(0, newrpm)

	if(!compressor.starter || newrpm > 1000)
		compressor.rpmtarget = newrpm
	//endif was here

	if(compressor.gas.tot_gas()>0)
		var/oamount = min(compressor.gas.tot_gas(), (compressor.rpm+100)/35000*compressor.capacity)
		compressor.gas.turf_add(outturf, oamount)
		outturf.firelevel = outturf.poison

	if(lastgen > 100)
		overlays += image('pipes.dmi', "turb-o", FLY_LAYER)


	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

/obj/machinery/power/turbine/attack_ai(mob/user)

	if(stat & (BROKEN|NOPOWER))
		return

	interact(user)

/obj/machinery/power/turbine/attack_hand(mob/user)

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	interact(user)

/obj/machinery/power/turbine/proc/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (NOPOWER|BROKEN)) && (!istype(user, /mob/ai)) )
		user.machine = null
		user << browse(null, "window=turbine")
		return

	user.machine = src

	var/t = "<TT><B>Gas Turbine Generator</B><HR><PRE>"

	var/gen = max(0, lastgen - (compressor.starter * COMPSTARTERLOAD) )
	t += "Generated power : [round(gen)] W<BR><BR>"

	t += "Turbine: [round(compressor.rpm)] RPM<BR>"

	t += "Starter: [ compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]"

	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=turbine")

	return

/obj/machinery/power/turbine/Topic(href, href_list)
	..()
	if(stat & BROKEN)
		return
	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
			return

	if (( usr.machine==src && ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))


		if( href_list["close"] )
			usr << browse(null, "window=turbine")
			usr.machine = null
			return

		else if( href_list["str"] )
			compressor.starter = !compressor.starter

		spawn(0)
			for(var/mob/M in viewers(1, src))
				if ((M.client && M.machine == src))
					src.interact(M)

	else
		usr << browse(null, "window=turbine")
		usr.machine = null

	return
