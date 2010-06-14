//*****************************
//	Main game automation loop
//*****************************
var/main_tick = 0
var/update_state = 0


/datum/control/cellular/process()
	set invisibility = 0
	set background = 1
	var/supplytime = 0

	for(var/obj/machinery/light/L in world)
		L.process()

	MainLoop:
	main_tick++

	update_state = main_tick % 4

	while(!( ticker ))
		for(var/mob/M in world)
			spawn( 0 )
				if(!M)
					return
				M.UpdateClothing()
				return
		sleep(10)
		updateap(1)

	time = (++time %10)
	supplytime = (++supplytime % 90)

	//Update the panels for admins
	updateap()

	//Check the escape pod recievers and see if any pods have landed
	for(var/T in poddocks)
		for(var/obj/O in T)
			if (istype(O, /obj/machinery/vehicle))
				var/obj/machinery/vehicle/V = O
				V.anchored = 1
				poddocks -= T
				spawn(10)
					var/obj/machinery/door/poddoor/P = locate(/obj/machinery/door/poddoor) in get_step(T, NORTH)
					P.closepod()
					P = locate(/obj/machinery/door/poddoor) in get_step(T, SOUTH)
					sleep(30)
					P.openpod()

	//Increase supply points
	if (!supplytime && supply_shuttle_points < 75)
		supply_shuttle_points += 1

	//Rotate the sun and set which solar panels can produce any power
	sun.calc_position()

	// ... I think someone else needs to fill in what this one does
	if(time%air_cycle == 0)
		spawn(-1)
			for(var/turf/space/space in world)
				if (space.updatecell && space.update_again)
					sleep(0)
			return

	//Let atmos run or something
	for(var/turf/station/T in world)
		if (T.updatecell && (T.update_again || T.firelevel >= 100000.0))
			sleep(0)

	sleep(3)

	//Update interface dialogs for machines
	for(var/mob/M in world)
		spawn( 0 )
			if(!M)
				return
			M.Life()
			if (M.machine && M.client && istype(M.machine, /obj/machinery))
				M.machine.UIUpdate(M.client)
			return

	sleep(3)

	//Process moving stuff
	for(var/obj/move/S in world)
		S.process()

	sleep(1)

	//Process Machines
	for(var/obj/machinery/M in machines)
		M.process()

	sleep(1)

	//Manage gas flows
	for(var/obj/machinery/M in gasflowlist)
		M.gas_flow()

	//And reset the powernets
	for(var/datum/powernet/P in powernets)
		P.reset()

	if (src.processing)
		sleep(2)
		goto MainLoop

	return
