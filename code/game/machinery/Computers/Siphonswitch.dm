/obj/machinery/computer/atmosphere/proc/returnarea()
	return

/obj/machinery/computer/atmosphere/siphonswitch/New()
	..()

	spawn(5)
		src.area = src.loc.loc

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

/obj/machinery/computer/atmosphere/siphonswitch/returnarea()
	var/list/C = list()
	for (var/area/A in src.area.superarea.areas)
		C += A.contents
	return C


/obj/machinery/computer/atmosphere/siphonswitch/verb/siphon_all()
	set src in oview(1)
	if(stat & NOPOWER)	return
	if (usr.stat)
		return
	usr << "Starting all siphon systems."
	for(var/obj/machinery/atmoalter/siphs/S in src.returnarea())
		S.reset(1, 0)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/atmosphere/siphonswitch/verb/stop_all()
	set src in oview(1)
	if(stat & NOPOWER)	return
	if (usr.stat)
		return
	usr << "Stopping all siphon systems."
	for(var/obj/machinery/atmoalter/siphs/S in src.returnarea())
		S.reset(0, 0)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/atmosphere/siphonswitch/verb/auto_on()
	set src in oview(1)
	if(stat & NOPOWER)	return
	if (usr.stat)
		return
	usr << "Starting automatic air control systems."
	for(var/obj/machinery/atmoalter/siphs/S in src.returnarea())
		S.reset(0, 1)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/atmosphere/siphonswitch/verb/release_scrubbers()
	set src in oview(1)

	if(stat & NOPOWER)	return
	if (usr.stat)
		return
	usr << "Releasing all scrubber toxins."
	for(var/obj/machinery/atmoalter/siphs/scrubbers/S in src.returnarea())
		S.reset(-1.0, 0)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/atmosphere/siphonswitch/verb/release_all()

	if(stat & NOPOWER)	return
	if (usr.stat)
		return
	usr << "Releasing all stored air."
	for(var/obj/machinery/atmoalter/siphs/S in src.returnarea())
		S.reset(-1.0, 0)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/atmosphere/siphonswitch/mastersiphonswitch/returnarea()

	return world



