/*

Elevator System

Base Design:

* 1x car in shaft, goes up and down in Z-level increments.
* Supports any number of stops per shaft, with stops not necessarily being on connecting floors (1 2 . . 3 . 4)
* Isolated network connected to a control computer somewhere (fake Router, a bit like antennas)
* Area-defined size and shape
* (Future) Cabling and Motors used to raise/lower the elevator
* (Future) Remote Monitoring computer



*/

//TODO reorganize this into multiple files, it's just a big lump atm to make initial dev easier


/datum/elevator
	var/id = ""
	var/list/datum/elevfloor/floors = list( )
	var/currentfloor = 0
	var/obj/machinery/computer/elevator/computer = null
	var/area/area = null
	var/doorstate = 0 //1 if the car doors are open
	var/moving = 0 //1 is the car is moving betwen floors or opening/closing doors
	var/enroute = 0 //1 is the car is travelling to a destination
	var/movedir = 1 //1 or -1 depending on car direction
	var/targetfloor = 0 //Where the elevator currently wants to be going
	var/minfloor = INFINITY //Bounds for the target checks
	var/maxfloor = -INFINITY

/datum/elevfloor
	var/list/req_access = null
	var/zlevel = 0
	var/name = ""
	var/called = 0
	var/req = 0
	var/obj/machinery/elevator/panel/panel = null
	var/list/obj/machinery/elevator/callbutton/buttons = list()
	var/list/turf/fixlights = list()

/datum/elevfloor/proc/clear()
	called = 0
	req = 0
	for (var/obj/machinery/elevator/callbutton/B in buttons)
		B.icon_state = "callbutton"
	panel.updateUsrDialog()

/datum/elevator/proc/get_floor(floornum)
	for(var/datum/elevfloor/EF in floors)
		if (EF.zlevel == floornum)
			return EF
	return null

/datum/elevator/proc/set_doors(open, floor = currentfloor)
	var/c = 0
	for(var/obj/machinery/door/poddoor/P in world)
		if (P.id != id)
			continue
		if (P.z != currentfloor)
			continue
		if (P.z == currentfloor)
			if (open && P.density)
				computer.transmitmessage(computer.createmessagetomachine("[P.get_password()] OPEN", P))
				c = 1
			else if (!P.density)
				computer.transmitmessage(computer.createmessagetomachine("[P.get_password()] CLOSE", P))
				c = 1
	doorstate = open
	if (c && floor)
		spawn(open ? 15 : 16)
			fixlights(floor)
	return c

/datum/elevator/proc/fixlights(var/floor)
	var/datum/elevfloor/EF = get_floor(floor)
	for (var/turf/T in EF.fixlights)
		T.sd_RasterLum()

/datum/elevator/proc/move(var/target_floor = targetfloor)
	if (moving)
		return
	moving = 1
	var/targ = currentfloor
	if (target_floor > targ)
		targ++
	if (target_floor < targ)
		targ--
	spawn(0)
		if (currentfloor != targ)
			if(set_doors(0, currentfloor))
				sleep(40)
			computer.use_power(400)
			for(var/area/B in area.superarea.areas)
				for(var/atom/movable/AM as mob|obj in B)
					if (AM.z != currentfloor || istype(AM, /obj/landmark))
						continue
					AM.Move(locate(AM.x, AM.y, targ))
				for(var/turf/T as turf in B)
					T.buildlinks()
			sleep(15)
			fixlights(currentfloor)
			fixlights(targ)
			currentfloor = targ
			sleep(40)
		if (currentfloor == target_floor)
			var/datum/elevfloor/EF = get_floor(currentfloor)
			EF.clear()
			set_doors(1, currentfloor)
			spawn(90)
				var/holdopen = 1
				while(holdopen)
					sleep(20)
					holdopen = 0
					for(var/obj/machinery/door/poddoor/D in world)
						if(D.id != id || D.z != currentfloor)
							continue
						var/list/contents = D.loc.contents.Copy()
						contents -= D
						contents -= locate(/obj/computercable, D.loc)
						contents -= locate(/obj/landmark, D.loc)
						contents -= locate(/obj/move, D.loc)
						if (contents.len)
							holdopen = 1
				set_doors(0, currentfloor)
		if (currentfloor == target_floor)
			enroute = 0
		moving = 0

/proc/get_elevator(id)
	if (elevators[id])
		return elevators[id]
	var/datum/elevator/E = new
	E.id = id
	elevators[id] = E
	return E