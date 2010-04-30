/obj/pnutube
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

/obj/pnutube/New()
	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)

/obj/pnutube/proc/get_connections()

	var/list/res = list()	// this will be a list of all connected  objects

	var/turf/T = get_step(src, d1)

	res += tubelist(T, src , d1, 1)

	T = get_step(src, d2)

	res += tubelist(T, src, d2, 1)


/proc/tubelist(var/turf/T, var/obj/source, var/d, var/unmarked=0)
	var/list/result = list()

	for(var/obj/pnutube/C in T)
		result += C
	for(var/obj/pnuexit/C in T)
		result += C

	result -= source

	return result


/obj/pnuexit
	name = "Compressed tube exit location"
	icon = 'pnu.dmi'
	icon_state = "exit"

/proc/path()
	var/obj/pnutube/start
	var/obj/pnutube/finish
	for(var/obj/pnutube/a in world)
		if(a.ID == "ALPHA")
			start = a
		if(a.ID == "BETA")
			finish = a

	var/list/path[] = AStar(start,finish,/obj/pnutube/proc/get_connections,/obj/pnutube/proc/Distance,10000,10000,0,0)
	for(var/obj/pnutube/a in path)
		a.icon_state = "exit"