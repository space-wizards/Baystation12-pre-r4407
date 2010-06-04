world/New()
	..()
	spawn(5)
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
			if(always_20C) return O2STANDARD
			return per_turf("O2")
	poison(n)
		if(n) poison += n//zone.gases["Plasma"] += n
		else
			if(always_20C) return 0
			return poison
	n2(n)
		if(zone && n)
			zone.gases["N2"] += n
		else
			if(always_20C) return N2STANDARD
			return per_turf("N2")
	sl_gas(n)
		if(zone && n) sl_gas += n//zone.gases["N2O"] += n
		else
			if(always_20C) return 0
			return sl_gas
	co2(n)
		if(zone && n) zone.gases["CO2"] += n
		else
			if(always_20C) return 0
			return per_turf("CO2")
	per_turf(g)
		if(always_20C) return CELLSTANDARD
		if(zone)
			if(g)
				return zone.per_turf(g)
			else
				return zone.per_turf()+poison+sl_gas
		else
			return 0

	temp(n)
		if(always_20C)
			return T20C
		if(zone)
			if(n)
				zone.temp = max(2.7, zone.temp + (n / zone.contents.len))
			else return zone.temp
		return T20C

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
