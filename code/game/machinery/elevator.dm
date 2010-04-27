/*

Elevator System

Base Design:

* 1x car in shaft, goes up and down in Z-level increments.
* Supports any number of stops per shaft, with stops not necessarily being on connecting floors (1 2 . . 3 . 4)
* Isolated network connected to a control computer somewhere (fake Router, a bit like antennas)
* Area-defined size and shape
* (Future) Cabling and Motors used to raise/lower the elevator
* (Future) Remote monitoring computer



*/

//TODO reorganize this into multiple files, it's just a big lump atm to make initial dev easier
//TODO the panel


/obj/machinery/computer/elevator
	name = "Elevator Control Computer"
	icon_state = "elev"
	var/id = ""
	var/datum/elevator/elevator = null
	var/move_timer = 0

/obj/machinery/elevator/panel
	icon_state = "panel"
	icon='elevator.dmi'
	name = "Elevator Panel"
	var/id = ""
	var/datum/elevator/elevator = null

/obj/machinery/elevator/panel/New()
	..()
	spawn(5)
		elevator = get_elevator(id)
		for (var/datum/elevfloor/EF in elevator.floors)
			EF.panel = src

/obj/machinery/elevator/panel/process()
	if (stat & (NOPOWER|BROKEN))
		return
	use_power(55)

/obj/machinery/elevator/panel/proc/Interact(var/mob/user)
	var/dat = "<31>Elevator Console</h3><hr>"

	dat += "Current Floor: [elevator.currentfloor] <br>"

	dat += "<table><tr><th>Floor</th><td>&nbsp;</td><th>Call</th></tr>"

	for (var/datum/elevfloor/EF in elevator.floors)
		dat += "<tr><td>[EF.name]</td><td>&nbsp;</td><td>[EF.req ? "Called" : "<a href='?src=\ref[src];call=[EF.zlevel]'>Call</a>" ]</td></tr>"

	dat += "</table><br>"

	dat += "<a href='?src=\ref[user];mach_close=elevpanel'>Close</a>"

	user << browse(dat, "window=elevpanel;size=250x500")

/obj/machinery/elevator/panel/Topic(href, href_list)
	if (..()) return
	usr.machine = src

	if (href_list["call"])
		var/datum/elevfloor/EF = elevator.get_floor(text2num(href_list["call"]))
		EF.req = 1
		updateUsrDialog()

/obj/machinery/elevator/callbutton
	name = "Call Button"
	icon='elevator.dmi'
	icon_state = "callbutton"
	var/id = ""
	var/datum/elevfloor/floor = null

/obj/machinery/elevator/callbutton/New()
	..()
	spawn(5)
		var/datum/elevator/E = get_elevator(id)
		floor = E.get_floor(z)
		floor.buttons += src

/obj/machinery/elevator/callbutton/attack_hand(var/mob/user)
	icon_state = "callbutton1"
	floor.called = 1
	user << "\blue You call the elevator"

/obj/machinery/elevator/callbutton/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/callbutton/attack_paw(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/callbutton/attackby(var/item/weapon/W, var/mob/user)
	return attack_hand(user)

/obj/landmark/elevator
	var/id = ""

/obj/landmark/elevator/cab
	name = "Elevator Cab Start Position"

/obj/landmark/elevator/stop
	name = "(Floor Name Here)"

/obj/landmark/elevator/cab/New()
	..()
	var/datum/elevator/E = get_elevator(id)
	E.currentfloor = z
	E.area = loc.loc
	del src

/obj/landmark/elevator/stop/New()
	..()
	var/datum/elevator/E = get_elevator(id)
	var/datum/elevfloor/EF = new
	EF.name = name
	EF.req_access = req_access
	EF.zlevel = z
	E.floors += EF
	if (z < E.minfloor)
		E.minfloor = z
	else if (z > E.maxfloor)
		E.maxfloor = z
	del src

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
				return


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

/datum/elevator/proc/set_doors(open)
	var/c = 0
	for(var/area/B in area.superarea.areas)
		for(var/obj/machinery/door/poddoor/P in B)
			if (P.z != currentfloor)
				continue
			if (P.z == currentfloor)
				if (open && P.density)
					P.openpod()
					c = 1
				else if (!P.density)
					P.closepod()
					c = 1
	doorstate = open
	return c

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
		if(set_doors(0))
			sleep(40)
		computer.use_power(400)
		for(var/area/B in area.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				if (AM.z != currentfloor)
					continue
				AM.z = targ
				AM.Move()
			for(var/turf/T as turf in B)
				T.buildlinks()
		sleep(15)
		currentfloor = targ
		if (currentfloor == target_floor)
			var/datum/elevfloor/EF = get_floor(currentfloor)
			EF.clear()
			sleep(40)
			set_doors(1)
			spawn(80)
				var/holdopen = 1
				while(holdopen)
					sleep(10)
					holdopen = 0
					for(var/obj/machinery/door/poddoor/D in world)
						if(D.id != id || D.z != currentfloor)
							continue
						var/list/contents = D.loc.contents
						contents -= D
						contents -= locate(/obj/computercable, D.loc)
						contents -= locate(/obj/move, D.loc)
						if (contents.len)
							holdopen = 1
				set_doors(0)
		moving = 0
		enroute = 0

/proc/get_elevator(id)
	if (elevators[id])
		return elevators[id]
	var/datum/elevator/E = new
	E.id = id
	elevators[id] = E
	return E

/obj/move/elevator
	icon = 'shuttle.dmi'

/obj/move/elevator/floor
	name = "Elevator Floor"
	icon_state = "floor3"

/obj/move/elevator/wall
	name = "Elevator Floor"
	icon_state = "wall"
	density = 1
	opacity = 1
	updatecell = 0