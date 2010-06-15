/datum/engine_eject/proc/ejectstart()
	if (!( src.status ))
		if (src.timeleft <= 0)
			src.timeleft = 60
		world << "\red <B>Alert: Ejection Sequence for Engine Module has been engaged.</B>"
		world << text("\red <B>Ejection Time in T-[] seconds!</B>", src.timeleft)
		src.resetting = 0

		var/list/EA = engine_areas()

		for(var/area/A in EA)
			A.eject = 1
			A.updateicon()

		src.status = 1
		for(var/obj/machinery/computer/engine/E in machines)
			E.icon_state = "engine-alert"
			//Foreach goto(113)
		spawn( 0 )
			src.countdown()
			return
	return

/datum/engine_eject/proc/resetcount()

	if (!( src.status ))
		src.resetting = 1
	sleep(50)
	if (src.resetting)
		src.timeleft = 60
		world << "\red <B>Alert: Ejection Sequence Countdown for Engine Module has been reset.</B>"
	return

/datum/engine_eject/proc/countdone()

	src.status = -1.0

	var/list/E = engine_areas()

	var/list/engineturfs = list()
	for(var/area/EA in E)
		EA.eject = 0
		EA.updateicon()
		for(var/turf/ET in EA)
			engineturfs += ET

	defer_powernet_rebuild = 1
	moving_zone = 1
	for(var/turf/T in engineturfs)
		var/turf/S = new T.type( locate(T.x, T.y, engine_eject_z_target) )

		var/area/A = T.loc

		for(var/atom/movable/AM as mob|obj in T)
			AM.loc = S

		/*S.oxygen = T.oxygen
		S.poison = T.poison()
		S.co2 = T.co2
		S.sl_gas = T.sl_gas
		S.n2 = T.n2
		S.temp = T.temp
		S.buildlinks()*/
		var/zone/Z = T.zone
		if(Z)
			Z.contents -= T
			Z.contents += Z
			S.zone = Z

		A.contents += S
		var/turf/P = new T.type( locate(T.x, T.y, T.z) )
		var/area/D = locate(/area/dummy)
		D.contents += P

		//T = null

		del(T)
		P.buildlinks()

	defer_powernet_rebuild = 0
	moving_zone = 0
	spawn(1)
		makepowernets()
	world << "\red <B>Engine Ejected!</B>"
	for(var/obj/machinery/computer/engine/CE in machines)
		CE.icon_state = "engine-ejected"
	return

/datum/engine_eject/proc/stopcount()

	if (src.status > 0)
		src.status = 0
		world << "\red <B>Alert: Ejection Sequence for Engine Module has been disengaged!</B>"

		var/list/E = engine_areas()

		for(var/area/A in E)
			A.eject = 0
			A.updateicon()

		for(var/obj/machinery/computer/engine/CE in machines)
			CE.icon_state = null
			//Foreach goto(84)
	return

/datum/engine_eject/proc/countdown()

	if (src.timeleft <= 0)
		spawn( 0 )
			countdone()
			return
		return
	if (src.status > 0)
		src.timeleft--
		if ((src.timeleft <= 15 || src.timeleft == 30))
			world << text("\red <B>[] seconds until engine ejection.</B>", src.timeleft)
		spawn( 10 )
			src.countdown()
			return
	return


//returns a list of areas that are under /area/engine
/datum/engine_eject/proc/engine_areas()
	var/list/L = list()
	for(var/area/A in world)
		if(istype(A, /area/engine))
			L += A

	return L
