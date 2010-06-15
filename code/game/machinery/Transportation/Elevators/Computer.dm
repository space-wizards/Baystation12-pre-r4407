
/obj/machinery/computer/elevator
	name = "Elevator Control Computer"
	icon_state = "elev"
	var/id = ""
	var/datum/elevator/elevator = null
	var/move_timer = 0

/obj/machinery/computer/elevator/New()
	..()
	elevator = get_elevator(id)
	elevator.computer = src

/obj/machinery/computer/elevator/process()
	//If the control computer isn't working, the elevator is going to be doing jack squat
	if (stat & (BROKEN|NOPOWER))
		return
	use_power(75)

	//If the car is busy, don't do anything else
	if (elevator.moving || elevator.doorstate)
		return

	if (elevator.enroute)
		elevator.move()
		for(var/f = elevator.currentfloor + elevator.movedir, f != elevator.targetfloor && f <= elevator.maxfloor && f >= elevator.minfloor, f += elevator.movedir)
			var/datum/elevfloor/EF = elevator.get_floor(f)
			if (!EF)
				continue
			if (EF.called || EF.req)
				elevator.targetfloor = f
				return

	else //Scan for somewhere to go to, giving preference to those farther along my current direction
		for(var/f = elevator.currentfloor, f <= elevator.maxfloor && f >= elevator.minfloor, f+= elevator.movedir)
			var/datum/elevfloor/EF = elevator.get_floor(f)
			if (!EF)
				continue
			if (EF.called || EF.req)
				elevator.targetfloor = f
				elevator.enroute = 1
				return

		for(var/f = elevator.currentfloor, f <= elevator.maxfloor && f >= elevator.minfloor, f-= elevator.movedir)
			var/datum/elevfloor/EF = elevator.get_floor(f)
			if (!EF)
				continue
			if (EF.called || EF.req)
				elevator.targetfloor = f
				elevator.movedir = -elevator.movedir
				elevator.enroute = 1
