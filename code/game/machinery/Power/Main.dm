/obj/machinery/power/infinite/process()
	add_avail(INFINITY)

/obj/machinery/power/proc/add_avail(var/amount)
	if(powernet)
		powernet.newavail += amount

/obj/machinery/power/proc/add_load(var/amount)
	if(powernet)
		powernet.newload += amount

/obj/machinery/power/proc/surplus()
	if(powernet)
		return powernet.avail-powernet.load
	else
		return 0

/obj/machinery/power/proc/avail()
	if(powernet)
		return powernet.avail
	else
		return 0

// returns true if the area has power on given channel (or doesn't require power).
// defaults to equipment channel

/obj/machinery/proc/powered(var/chan = EQUIP)
	var/area/A = src.loc.loc		// make sure it's in an area
	if(!A || !isarea(A))
		return 0					// if not, then not powered

		//Qwertyuiopas: We want to be more area independant!
		//however, the code is probably not ready, or at least not tested
		//I'll finish it ASAP

		//Why is this here, it'll never get used? -Sukasa

		var/obj/machinery/power/P
		if(istype(src,/obj/machinery/power))
			P=src
		if(P && P.directwired)
			for(var/obj/cable/C in orange(1))
				if(C.netnum)
					var/d = get_dir(C.loc, src)
					if(C.d1==d||C.d2==d)
						var/datum/powernet/N=powernets[C.netnum]
						for(var/obj/machinery/power/terminal/T in N)
							if(istype(T.master, /obj/machinery/power/apc))
								var/obj/machinery/power/apc/AA= T.master
								if(AA.cell.charge>0 && (AA.equipment == 2 || AA.equipment == 3))
									return 1
		else
			for(var/obj/cable/C in loc)
				if(C.netnum)
					var/datum/powernet/N=powernets[C.netnum]
					for(var/obj/machinery/power/terminal/T in N)
						if(istype(T.master, /obj/machinery/power/apc))
							var/obj/machinery/power/apc/AA= T.master
							if(AA.cell.charge>0 && (AA.equipment == 2 || AA.equipment == 3))
								return 1
		return 0


	return A.powered(chan)	// return power status of the area

// increment the power usage stats for an area

/obj/machinery/proc/use_power(var/amount, var/chan=EQUIP) // defaults to Equipment channel
	var/area/A = src.loc.loc		// make sure it's in an area
	if(!A || !isarea(A))
		return

	A.use_power(amount, chan)


/obj/machinery/proc/power_change()		// called whenever the power settings of the containing area change
										// by default, check equipment channel & set flag
										// can override if needed
	if(powered())
		stat &= ~NOPOWER
	else

		stat |= NOPOWER
	return


// attach a wire to a power machine - leads from the turf you are standing on

/obj/machinery/power/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/weapon/cable_coil))

		var/obj/item/weapon/cable_coil/coil = W

		var/turf/T = user.loc

		if(T.intact || !istype(T, /turf/station/floor))
			return

		if(get_dist(src, user) > 1)
			return

		if(!directwired)		// only for attaching to directwired machines
			return

		var/dirn = get_dir(user, src)


		for(var/obj/cable/LC in T)
			if(LC.d1 == dirn || LC.d2 == dirn)
				user << "There's already a cable at that position."
				return

		var/obj/cable/NC = new(T)
		NC.d1 = 0
		NC.d2 = dirn
		NC.add_fingerprint()
		NC.updateicon()
		spawn(1)
			NC.update_network()
		coil.use(1)
		return
	else
		..()
	return


/atom/proc/electrocute(mob/user, prb, netnum)

	if(!prob(prb))
		return 0

	if(!netnum)		// unconnected cable is unpowered
		return 0

	var/datum/powernet/PN			// find the powernet
	if(powernets && powernets.len >= netnum)
		PN = powernets[netnum]

	if(PN && PN.avail > 0)		// is it powered?
		var/prot = 0

		if(istype(user, /mob/human))
			var/mob/human/H = user
			if(H.gloves)
				var/obj/item/weapon/clothing/gloves/G = H.gloves

				prot = G.elec_protect
		else if (istype(user, /mob/ai))
			return 0

		if(prot == 10)		// elec insulted gloves protect completely
			return 0

		prot++

		var/obj/effects/sparks/O = new /obj/effects/sparks( src.loc )
		O.dir = pick(NORTH, SOUTH, EAST, WEST)
		spawn( 0 )
			O.Life()

		var/shock_damage = 0
		if(PN.avail > 750000)	//someone juiced up the grid enough, people going to die!
			shock_damage = min(rand(70,145),rand(70,145))/prot
		else if(PN.avail > 100000)
			shock_damage = min(rand(35,110),rand(35,110))/prot
		else if(PN.avail > 75000)
			shock_damage = min(rand(30,100),rand(30,100))/prot
		else if(PN.avail > 50000)
			shock_damage = min(rand(25,90),rand(25,90))/prot
		else if(PN.avail > 25000)
			shock_damage = min(rand(20,80),rand(20,80))/prot
		else if(PN.avail > 10000)
			shock_damage = min(rand(20,65),rand(20,65))/prot
		else
			shock_damage = min(rand(20,45),rand(20,45))/prot

//		messageadmins("\blue <B>ADMIN: </B>DEBUG: shock_damage = [shock_damage] PN.avail = [PN.avail] user = [user] netnum = [netnum]")

		user.burn_skin(shock_damage)
		user << "\red <B>You feel a powerful shock course through your body!</B>"
		sleep(1)

		if(user.stunned < shock_damage)	user.stunned = shock_damage
		if(user.weakened < 20/prot)	user.weakened = 20/prot
		for(var/mob/M in viewers(src))
			if(M == user)	continue
			M.show_message("\red [user.name] was shocked by the [src.name]!", 3, "\red You hear a heavy electrical crack", 2)
		return 1
	return 0






// the powernet datum
// each contiguous network of cables & nodes


// rebuild all power networks from scratch

/proc/makepowernets()
	if (defer_powernet_rebuild || powernets_building)
		return
	powernets_building = 1
	var/netcount = 0
	powernets = list()

	for(var/obj/cable/PC in world)
		PC.netnum = 0
	for(var/obj/machinery/power/M in machines)
		if(M.netnum >=0)
			M.netnum = 0

	for(var/obj/cable/PC in world)
		if(!PC.netnum)
			PC.netnum = ++netcount

			if(Debug) world.log << "Starting mpn at [PC.x],[PC.y] ([PC.d1]/[PC.d2]) #[netcount]"
			powernet_nextlink_counter = 0
			powernet_nextlink(PC, PC.netnum)

	if(Debug) world.log << "[netcount] powernets found"

	for(var/L = 1 to netcount)
		var/datum/powernet/PN = new()
		//PN.tag = "powernet #[L]"
		powernets += PN
		PN.number = L


	for(var/obj/cable/C in world)
		var/datum/powernet/PN = powernets[C.netnum]
		PN.cables += C

	for(var/obj/machinery/power/M in machines)
		if(M.netnum<=0)		// APCs have netnum=-1 so they don't count as network nodes directly
			continue

		M.powernet = powernets[M.netnum]
		M.powernet.nodes += M

	powernets_building = 0
	world.log_game("Finished building powernets ([powernets.len] nets)")



// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with netnum==0

/proc/power_list(var/turf/T, var/source, var/d, var/unmarked=0)
	var/list/result = list()
	var/fdir = (!d || d & (UP|DOWN))? 0 : turn(d, 180)	// the opposite direction to d (or 0 if d==0)

	for(var/obj/machinery/power/P in T)
		if(P.netnum < 0)	// exclude APCs
			continue

		if(P.directwired)	// true if this machine covers the whole turf (so can be joined to a cable on neighbour turf)
			if(!unmarked || !P.netnum)
				result += P
		else if(d == 0)		// otherwise, need a 0-X cable on same turf to connect
			if(!unmarked || !P.netnum)
				result += P


	for(var/obj/cable/C in T)
		if(C.d1 == fdir || C.d2 == fdir)
			if(!unmarked || !C.netnum)
				result += C
		if((C.d1 | d) == (UP|DOWN))
			if(!unmarked || !C.netnum)
				result += C

	result -= source

	return result


/obj/cable/proc/get_connections()

	var/list/res = list()	// this will be a list of all connected power objects

	var/turf/T
	if(!d1)
		T = src.loc		// if d1=0, same turf as src
	else if(!(d1 & (UP|DOWN)))
		T = get_step(src, d1)

	if(!(d1 & (UP|DOWN)))
		res += power_list(T, src , d1, 1)

	T = get_step(src, d2)

	res += power_list(T, src, d2, 1)

	if(d1 & (UP|DOWN))

		if(d1 & UP)
			T = locate(src.x, src.y, src.z + 1)
			res += power_list(T, src , d1, 1)

		if(d1 & DOWN)
			T = locate(src.x, src.y, src.z - 1)
			res += power_list(T, src , d1, 1)

	return res


/obj/machinery/power/proc/get_connections()

	if(!directwired)
		return get_indirect_connections()

	var/list/res = list()
	var/cdir

	for(var/turf/T in orange(1, src))

		cdir = get_dir(T, src)

		for(var/obj/cable/C in T)

			if(C.netnum)
				continue

			if(C.d1 == cdir || C.d2 == cdir)
				res += C

	return res

/obj/machinery/power/proc/get_indirect_connections()

	var/list/res = list()

	for(var/obj/cable/C in src.loc)

		if(C.netnum)
			continue

		if(C.d1 == 0)
			res += C

	return res

var/powernet_nextlink_counter = 0
var/powernet_nextlink_processing = 0
/proc/powernet_nextlink(var/obj/O, var/num)
	if(global.powerfailure)
		return
	while(powernet_nextlink_processing)
		sleep(1)
	var/list/P
	powernet_nextlink_counter = 0
	//world.log << "start: [O] at [O.x].[O.y]"

	while(1)//powernet_nextlink_counter < 100000)//was while(1), but *might* be better to do it this way. 100 thousand iterations should be enough, right?
		powernet_nextlink_counter++
		if(powernet_nextlink_counter > 40)
			powernet_nextlink_processing = 1
			sleep(1)//During this sleep(), another nextlink() *could* begin processing, so stop it early.
			powernet_nextlink_processing = 0
			powernet_nextlink_counter = 0
		if( istype(O, /obj/cable) )
			var/obj/cable/C = O

			C.netnum = num

		else if( istype(O, /obj/machinery/power) )

			var/obj/machinery/power/M = O

			M.netnum = num


		if( istype(O, /obj/cable) )
			var/obj/cable/C = O

			P = C.get_connections()

		else if( istype(O, /obj/machinery/power) )

			var/obj/machinery/power/M = O

			P = M.get_connections()

		if(P.len == 0)
			//world.log << "end1"
			return

		O = P[1]


		for(var/L = 2 to P.len)

			powernet_nextlink(P[L], num)

		//world.log << "next: [O] at [O.x].[O.y]"







// cut a powernet at this cable object

/datum/powernet/proc/cut_cable(var/obj/cable/C)

	var/turf/T1 = C.loc
	if(C.d1)
		T1 = get_step(C, C.d1)

	var/turf/T2 = get_step(C, C.d2)

	var/list/P1 = power_list(T1, C, C.d1)	// what joins on to cut cable in dir1

	var/list/P2 = power_list(T2, C, C.d2)	// what joins on to cut cable in dir2

	if(Debug)
		for(var/obj/O in P1)
			world.log << "P1: [O] at [O.x] [O.y] : [istype(O, /obj/cable) ? "[O:d1]/[O:d2]" : null] "
		for(var/obj/O in P2)
			world.log << "P2: [O] at [O.x] [O.y] : [istype(O, /obj/cable) ? "[O:d1]/[O:d2]" : null] "



	if(P1.len == 0 || P2.len ==0)			// if nothing in either list, then the cable was an endpoint
											// no need to rebuild the powernet, just remove cut cable from the list
		cables -= C
		if(Debug) world.log << "Was end of cable"
		return

	// zero the netnum of all cables & nodes in this powernet

	for(var/obj/cable/OC in cables)
		OC.netnum = 0
	for(var/obj/machinery/power/OM in nodes)
		OM.netnum = 0


	// remove the cut cable from the network
	C.netnum = -1
	C.loc = null
	cables -= C



	powernet_nextlink_counter = 0
	powernet_nextlink(P1[1], number)		// propagate network from 1st side of cable, using current netnum

	// now test to see if propagation reached to the other side
	// if so, then there's a loop in the network

	var/notlooped = 0
	for(var/obj/O in P2)
		if( istype(O, /obj/machinery/power) )
			var/obj/machinery/power/OM = O
			if(OM.netnum != number)
				notlooped = 1
				break
		else if( istype(O, /obj/cable) )
			var/obj/cable/OC = O
			if(OC.netnum != number)
				notlooped = 1
				break

	if(notlooped)

		// not looped, so make a new powernet

		var/datum/powernet/PN = new()
		//PN.tag = "powernet #[L]"
		powernets += PN
		PN.number = powernets.len

		if(Debug) world.log << "Was not looped: spliting PN#[number] ([cables.len];[nodes.len])"

		for(var/obj/cable/OC in cables)

			if(!OC.netnum)		// non-connected cables will have netnum==0, since they weren't reached by propagation

				OC.netnum = PN.number
				cables -= OC
				PN.cables += OC		// remove from old network & add to new one

		for(var/obj/machinery/power/OM in nodes)
			if(!OM.netnum)
				OM.netnum = PN.number
				OM.powernet = PN
				nodes -= OM
				PN.nodes += OM		// same for power machines

		if(Debug)
			world.log << "Old PN#[number] : ([cables.len];[nodes.len])"
			world.log << "New PN#[PN.number] : ([PN.cables.len];[PN.nodes.len])"

	else
		if(Debug)
			world.log << "Was looped."
		//there is a loop, so nothing to be done
		return

	return



/datum/powernet/proc/reset()
	load = newload
	newload = 0
	avail = newavail
	newavail = 0


	viewload = 0.8*viewload + 0.2*load

	viewload = round(viewload)

	var/numapc = 0

	for(var/obj/machinery/power/terminal/term in nodes)
		if( istype( term.master, /obj/machinery/power/apc ) )
			numapc++

	if(numapc)
		perapc = avail/numapc

	netexcess = avail - load

	if( netexcess > 100)		// if there was excess power last cycle
		for(var/obj/machinery/power/smes/S in nodes)	// find the SMESes in the network
			S.restore()				// and restore some of the power that was used







