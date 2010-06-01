/proc/makepnunets(var/silence = 0)

	if(defer_pnunet_rebuild) //Because otherwise explosions will fuck your shit up like never before
		return

	var/netcount = 0
	var/wirelessnetcount = 0
	pnunets = list()

	for(var/obj/pnutube/C in world)
		C.cnetnum = 0
		++wirelessnetcount

	for(var/obj/pnutube/PC in world)
		if(!PC.pnunetnum)
			PC.pnunetnum = ++netcount
			pnunet_nextlink_counter = 0
			pnu_nextlink(PC, PC.pnunetnum)

	for(var/L = 0 to netcount)
		var/datum/pnunet/PN = new()
		pnunets += PN
		PN.number = L

	for(var/obj/pnutube/C in world)
		var/datum/pnunet/PN = pnunets[C.cnetnum]
		PN.cables += C

	return netcount

// returns a list of all -related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with cnetnum==0

/proc/get_dir_3d(var/atom/ref, var/atom/target)
	return get_dir(ref, target) | (target.z > ref.z ? UP : 0) | (target.z < ref.z ? DOWN : 0)

/proc/computer_list(var/turf/T, var/obj/source, var/d, var/unmarked=0)
	var/list/result = list()

	for(var/obj/computercable/C in T)
		if(!unmarked || !C.cnetnum)
			if (C.d1 == get_dir_3d(T, source.loc) || C.d2 == get_dir_3d(T, source.loc))
				result += C

	result -= source

	return result


/obj/computercable/proc/get_connections()

	var/list/res = list()	// this will be a list of all connected  objects

	var/turf/T = get_step_3d(src, d1)

	res += computer_list(T, src , d1, 1)

	T = get_step_3d(src, d2)

	res += computer_list(T, src, d2, 1)

	return res




var/pnunet_nextlink_counter = 0
var/pnunet_nextlink_processing = 0


/proc/pnunet_nextlink(var/obj/O, var/num)
	var/list/P

	while(1)
		if( istype(O, /obj/pnutube) )
			var/obj/computercable/C = O

			C.cnetnum = num


		if( istype(O, /obj/pnutube) )
			var/obj/pnutube/C = O

			P = C.get_connections()

		if(P.len == 0)
			return

		O = P[1]


		for(var/L = 2 to P.len)

			pnutube_nextlink(P[L], num)

// cut a powernet at this cable object

/datum/computernet/proc/cut_cable(var/obj/computercable/C)

	var/turf/T1 = get_step_3d(C, C.d1)

	var/turf/T2 = get_step_3d(C, C.d2)

	var/list/P1 = computer_list(T1, C, C.d1)	// what joins on to cut cable in dir1

	var/list/P2 = computer_list(T2, C, C.d2)	// what joins on to cut cable in dir2


	if(P1.len == 0 || P2.len ==0)			// if nothing in either list, then the cable was an endpoint
											// no need to rebuild the powernet, just remove cut cable from the list
		cables -= C
		if(DebugN) world.log << "Was end of cable"
		return

	// zero the cnetnum of all cables & nodes in this powernet

	for(var/obj/computercable/OC in cables)
		OC.cnetnum = 0
	for(var/obj/machinery/OM in nodes)
		OM.cnetnum = 0


	// remove the cut cable from the network
	C.cnetnum = -1
	C.loc = null
	cables -= C



	computernet_nextlink_counter = 0
	computernet_nextlink(P1[1], number)		// propagate network from 1st side of cable, using current cnetnum

	// now test to see if propagation reached to the other side
	// if so, then there's a loop in the network

	var/notlooped = 0
	for(var/obj/O in P2)
		if( istype(O, /obj/machinery) )
			var/obj/machinery/OM = O
			if(OM.cnetnum != number)
				notlooped = 1
				break
		else if( istype(O, /obj/computercable) )
			var/obj/computercable/OC = O
			if(OC.cnetnum != number)
				notlooped = 1
				break

	if(notlooped)

		// not looped, so make a new powernet

		var/datum/computernet/PN = new()
		//PN.tag = "powernet #[L]"
		pnunets += PN
		PN.number = pnunets.len

		if(DebugN) world.log << "Was not looped: spliting PN#[number] ([cables.len];[nodes.len])"

		for(var/obj/computercable/OC in cables)

			if(!OC.cnetnum)		// non-connected cables will have cnetnum==0, since they weren't reached by propagation

				OC.cnetnum = PN.number
				cables -= OC
				PN.cables += OC		// remove from old network & add to new one

		for(var/obj/machinery/OM in nodes)
			if(!OM.cnetnum)
				OM.cnetnum = PN.number
				OM.computernet = PN
				nodes -= OM
				PN.nodes += OM		// same for  machines

		if(DebugN)
			world.log << "Old PN#[number] : ([cables.len];[nodes.len])"
			world.log << "New PN#[PN.number] : ([PN.cables.len];[PN.nodes.len])"

	else
		if(DebugN)
			world.log << "Was looped."
		//there is a loop, so nothing to be done
		return

	return