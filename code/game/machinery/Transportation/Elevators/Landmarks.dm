/obj/landmark/elevator
	var/id = ""

/obj/landmark/elevator/cab
	name = "Elevator Cab Start Position"

/obj/landmark/elevator/stop
	name = "(Floor Name Here)"

/obj/landmark/elevator/fixlight
	name = "Lighting Patch"

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

/obj/landmark/elevator/fixlight/New()
	..()
	spawn(5)
		var/datum/elevator/E = get_elevator(id)
		var/datum/elevfloor/EF = E.get_floor(z)
		EF.fixlights += get_turf(src.loc)

