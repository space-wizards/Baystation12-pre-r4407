world/New()
	..()
	spawn(1)
		for(var/turf/T)
			T.updatecell = 0
		var/c = 0
		for(var/z = 1,z <= world.maxz,z++)
			for(var/x = 1,x <= world.maxx,x++)
				for(var/y = 1,y <= world.maxy,y++)
					var/turf/T = locate(x,y,z)
					if(T)
						if(!T.zone && !Zonetight(T) && CheckSpace(T))
							new/zone(T)
						c++
		world.log << "[c] Zones Placed."
		while(!ticker)
			sleep(5)
		for(var/obj/O)
			if(istype(O,/obj/machinery/door))
				if(!O.density && O:checkForMultipleDoors() && !(O.type in directional_types))
					ZoneSetup(O)
					OpenDoor(O)
turf/proc
	//isempty()
	//	return !Dense(src)
	//tot_gas()
	//	if(zone)
	//		return zone.per_turf()
	//	else
	//		return 0
	oxygen(n)
		if(zone && n)
			zone.gases["O2"] += n
		else
			if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return O2STANDARD
			return per_turf("O2")
	poison(n)
		if(n) poison += n//zone.gases["Plasma"] += n
		else
			if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return 0
			return poison
	n2(n)
		if(zone && n)
			zone.gases["N2"] += n
		else
			if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return N2STANDARD
			return per_turf("N2")
	sl_gas(n)
		if(zone && n) sl_gas += n//zone.gases["N2O"] += n
		else
			if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return 0
			return sl_gas
	co2(n)
		if(zone && n) zone.gases["CO2"] += n
		else
			if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return 0
			return per_turf("CO2")
	per_turf(g)
		if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return CELLSTANDARD
		if(zone)
			if(g)
				return zone.per_turf(g)
			else
				return zone.per_turf()+poison+sl_gas
		else
			return 0

	temp(n)
		if((locate(/obj/move) in src) || istype(src,/turf/station/shuttle)) return T20C
		if(zone)
			if(n)
				zone.temp += n
				zone.temp = max(2.7,zone.temp)
				//if(zone.speakmychild && n < 0) world << "Temperature -[abs(n)] - New Value [zone.temp]"
			else return zone.temp

obj/move/proc
	per_turf(g)
		if(!g)
			return CELLSTANDARD
		else
			if(g == "O2") return O2STANDARD
			if(g == "N2") return N2STANDARD
		return 0
	oxygen()
		return O2STANDARD
	n2()
		return N2STANDARD
	sl_gas()
		return 0
	co2()
		return 0
	poison()
		return 0
	temp_set()
		return T20C
	temp()
		return T20C
//	updatelinks()
/*
obj/move/proc/process()

/obj/move/proc/relocate(T as turf, degree)
	if (degree)
		for(var/atom/movable/A as mob|obj in src.loc)
			A.dir = turn(A.dir, degree)*/
			//*****RM as 4.1beta
			/*A.loc = T
	else
		for(var/atom/movable/A as mob|obj in src.loc)
			A.loc = T
	return


/turf/proc/get_gas()

	var/obj/substance/gas/tgas = new()

	tgas.oxygen = src.oxygen
	tgas.n2 = src.n2
	tgas.plasma = src.poison
	tgas.co2 = src.co2
	tgas.sl_gas = src.sl_gas
	tgas.temperature = src.temp
	tgas.maximum = CELLSTANDARD		// not actually a maximum

	return tgas*/
proc/WinCheck(turf/T,d)
	if(Airtight(T))
		//world << "Oho! I see through your tomfoolery! [T] is airtight!"
		return 0
	var/turf
		L = get_step(T,turn(d,90))
		R = get_step(T,turn(d,-90))
		F = get_step(T,d)
		LF = get_step(F,turn(d,90))
		RF = get_step(F,turn(d,-90))
	if(Airtight(F))
		//world << "Oho! Why not whore ourselves?"
		return 0
	var
		lock = 0
	if(Airtight(L,T) || Airtight(L,LF) || Airtight(F,LF))
		//world << "The left area is airtight."
		lock += 1
	if(Airtight(R,T) || Airtight(R,RF) || Airtight(F,RF))
		//world << "The right area is airtight."
		lock += 1
	if(DirBlocked(F,get_dir(F,T)))
		//world << "Ahhh screwwit."
		lock=0
	if(lock > 1) return 1
	else return 0

obj/machinery/door/block_zoning = 1
obj/machinery/door/poddoor/block_zoning = 1
obj/machinery/door/firedoor/is_open = 1
obj/move/wall/New()
	. = ..()
	if(isturf(loc))
		loc:accept_zoning = 0
obj/move/wall/Move()
	if(isturf(loc))
		loc:accept_zoning = 1
	. = ..()
	if(isturf(loc))
		loc:accept_zoning = 0

//turf/verb/Show_Zone()
//	set src in view()
//	ShowZone(zone)
//	world << "<u>Z[zones.Find(zone)]</u>"
//	for(var/g in zone.gases)
//		world << "<b>[g]</b>: [zone.turf_cache[g]] ([zone.gases[g]] total) - [zone.partial_pressure(g)]"
//	world << "<br><b>Total Pressure</b>: [zone.pressure()]"
//	world << "--------------------------"
//	world << "Connected Zones:"
//	for(var/zone/Z in zone.connections)
//		world << "<small><u>Z[zones.Find(Z)]</u></small>"
//		for(var/g in zone.gases)
//			world << "<small><b>[g]</b>: [Z.turf_cache[g]] ([Z.gases[g]] total) - [Z.partial_pressure(g)]</small>"
//		world << "<small><br><b>Total Pressure</b>: [Z.pressure()]</small>"