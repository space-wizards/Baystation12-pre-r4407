/obj/machinery/pnutube
	level = 1
	anchored =1
	name = "Compressed air tube"
	desc = "A rigid tube used for transfering items across the station"
	icon = 'pnu.dmi'
	icon_state = "2-4"
	var/d1 = 0
	var/d2 = 1
	layer = 2.5
	var/ID = 0
	//layer = 10
	pathweight = 1
	proc
		Distance(obj/t)
			if(get_dist(src,t) == 1)
				var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
				//Multiply the cost by the average of the pathweights of the
				//tile being entered and tile being left
				cost *= (pathweight+t.pathweight)/2
				return cost
			else
				return get_dist(src,t)

/obj/machinery/pnutube/New()
	..()
	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)

/obj/machinery/pnutube/proc/get_connections()

	world << "CALLED"

	var/list/res = list()	// this will be a list of all connected  objects

	var/turf/T = get_step(src, d1)

	res += tubelist(T, src , d1, 1)

	T = get_step(src, d2)

	res += tubelist(T, src, d2, 1)

	return res

/proc/tubelist(var/turf/T, var/obj/source, var/d, var/unmarked=0)
	var/list/result = list()

	for(var/obj/machinery/pnutube/C in T)
		result += C
	for(var/obj/machinery/pnuexit/C in T)
		result += C

	result -= source

	return result

/obj/machinery/pnutube/process()
	for(var/obj/item/weapon/box/B in src.contents)
		world << "HEY"
		spawn(3)
			if(B.path.len >= 1)
				B.loc = B.path[1]
				B.path.Cut(1,2)
				world << "A"

/obj/machinery/pnuexit
	name = "Compressed tube exit location"
	var/locname = "DEFAULT"
	icon = 'pnu.dmi'
	icon_state = "end"
	var/obj/machinery/pnutube/Connected
	proc
		Distance(obj/t)
			if(get_dist(src,t) == 1)
				var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
				//Multiply the cost by the average of the pathweights of the
				//tile being entered and tile being left
				cost *= (pathweight+t.pathweight)/2
				return cost
			else
				return get_dist(src,t)
/obj/machinery/pnuexit/process()
	for(var/obj/O in src.contents)
		O.loc = src.loc

/obj/machinery/pnuexit/New()
	..()
	for(var/obj/machinery/pnutube/C in src.loc)
		Connected = C

/obj/machinery/pnuexit/attackby(obj/item/weapon/box/B as obj,mob/user as mob)
	user.drop_item()
	B.loc = Connected
	B.path = AStar(B.loc,B.destination,/obj/machinery/pnutube/proc/get_connections,/obj/machinery/pnutube/proc/Distance)
	for(var/obj/A in B.path)
		world << "[A.name],[A.x],[A.y]"