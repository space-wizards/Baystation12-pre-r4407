/obj/move/CheckPass(O as mob|obj)
	return !( src.density )

/obj/move/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/move/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/obj/move/proc/res_vars()
	oldoxy = oxygen
	tmpoxy = oxygen

	oldpoison = poison
	tmppoison = poison

	oldco2 = co2
	tmpco2 = co2

	osl_gas = sl_gas
	tsl_gas = sl_gas

	on2 = src.n2
	tn2 = src.n2

	otemp = temp
	ttemp = temp

	update_again = 1

	return

/obj/move/proc/relocate(T as turf, degree)
	if (degree)
		for(var/atom/movable/A as mob|obj in src.loc)
			A.dir = turn(A.dir, degree)
			//*****RM as 4.1beta
			A.loc = T
	else
		for(var/atom/movable/A as mob|obj in src.loc)
			A.loc = T
	return

/obj/move/proc/unburn()
	sd_SetLuminosity(0)
	src.icon_state = initial(src.icon_state)
	return


/obj/move/proc/Neighbors()
	var/list/L = cardinal.Copy()
	for(var/obj/machinery/door/window/D in src.loc)
		if(!( D.density ))
			continue

		//++++++
		//L -= D.dir

		if (D.dir & 12)
			L -= SOUTH
		else
			L -= EAST

	for(var/obj/window/D in src.loc)
		if(!( D.density ))
			continue
		L -= D.dir
		if (D.dir == SOUTHWEST)
			L.len = null
			return L

	return L

/obj/move/proc/FindTurfs()
	var/list/L = list(  )
	for(var/dir in src.Neighbors())
		var/turf/T = get_step(src.loc, dir)


		//++++++

		if(!( T ))
			goto Label_299
		L += T
		var/direct = turn(dir, 180)
		//*****RM as 4.1beta

		for(var/obj/machinery/door/window/D in T)
			if(!( D.density ))
				goto Label_181
			//var/direct = get_dir(src, T)
			if ((D.dir & 12))
				if (dir & 1)	// was direct&1
					L -= T
					goto Label_181
			else
				if(dir & 8) // was direct&8
					L -= T
					goto Label_181
			Label_181:

		for(var/obj/window/D in T)
			if(!( D.density ))
				goto Label_294
			//var/direct = get_dir(T, src.loc)
			if (D.dir == SOUTHWEST)
				L -= T
				goto Label_294
			else
				if(direct == D.dir)
					L -= T


			Label_294:

		//*****
		Label_299:
		if ((locate(/obj/move, T) && T in L))
			L -= T
			var/obj/move/O = locate(/obj/move, T)
			if (O.updatecell)
				L += O
		else
			if ((isturf(T) && !( T.updatecell )))
				L -= T

	return L


/obj/move/proc/tot_gas()
	return co2 + oxygen + poison + sl_gas + n2

/obj/move/proc/process()
	if(locate(/obj/shuttle/door, src.loc))
		var/obj/shuttle/door/D = locate(/obj/shuttle/door, src.loc)
		src.updatecell = !(D.density)
	for(var/obj/machinery/door/D2 in src.loc)
		if(D2 && D2.density)
			src.updatecell = !(D2.density)
			break
	if (!src.updatecell)
		return
	if ((locate(/obj/effects/water, src.loc) || src.firelevel < 900000.0))
		src.firelevel = 0
		//cool due to water
		temp += (T20C - temp) / vsc.FIRERATE



	return

/obj/move/wall/New()
	var/F = locate(/obj/move/floor, src.loc)
	if (F)
		del(F)
	return

/obj/move/wall/process()
	src.updatecell = 0
	return

/obj/move/wall/blob_act()
	del(src)
	return

/obj/move/New()
	src.tmpoxy = src.oxygen
	src.oldoxy = src.oxygen
	src.tmppoison = src.poison
	src.oldpoison = src.poison
	src.tmpco2 = src.co2
	src.oldco2 = src.co2
	src.tn2 = src.n2
	src.on2 = src.n2

	otemp = temp
	ttemp = temp
	..()
	return

/turf/proc/res_vars()
	update_again = 1
	return

/turf/proc/unburn()

	sd_SetLuminosity(0)
	src.icon_state = initial(src.icon_state)
	return


//*****


// returns 0 if turf is dense or contains a dense object
// returns 1 otherwise
/turf/proc/isempty()
	if(src.density)
		return 0
	for(var/atom/A in src)
		if(A.density)
			return 0
	return 1


/turf/proc/Neighbors()

	var/list/L = cardinal.Copy()
	for(var/obj/machinery/door/window/D in src)
		if(!( D.density ))
			goto Label_96 //continue
		//+++++
		//L -= D.dir

		if (D.dir & 12)
			L -= SOUTH
		else
			L -= EAST

		Label_96
		//Foreach goto(34)
	for(var/obj/window/D in src)
		if(!( D.density ))
			goto Label_178 //continue
		L -= D.dir
		if (D.dir == SOUTHWEST)
			L.len = null
			return L
		Label_178
		//Foreach goto(111)
	return L

/turf/proc/FindTurfs()

	var/list/L = list(  )
	if (locate(/obj/move, src))
		return list(  )
	for(var/dir in src.Neighbors())
		var/turf/T = get_step(src, dir)
		//*****RM

		//
		if((!( T ) || !( T.updatecell )))
			goto Label_317

		L += T
		var/direct = turn(dir, 180)
		//*****RM as 4.1beta

		for(var/obj/machinery/door/window/D in T)
			if(!( D.density ))
				goto Label_201
			//var/direct = get_dir(src, T)
			if (D.dir & 12)
				if((dir & 1))		// was (direct & 1)
					L -= T
					goto Label_201
			else
				if(dir & 8)			//was (direct&8)
					L -= T

			Label_201:
			//Foreach goto(101)

		for(var/obj/window/D in T)
			if(!( D.density ))
				goto Label_312
			//var/direct = get_dir(T, src)
			if (D.dir == SOUTHWEST)
				L -= T
				goto Label_312
			else
				if(direct == D.dir)
					L -= T

			Label_312:

			//Foreach goto(219)

		//*****

		Label_317:
		//Foreach goto(40)

	for(var/turf/T in L)
		if (locate(/obj/move, T))
			L -= T
			var/obj/move/O = locate(/obj/move, T)
			if (O.updatecell)
				L += O
		//Foreach goto(333)
	return L


/turf/proc/setlink(dir, var/turf/T)

	switch(dir)
		if(1)
			linkN = T
		if(2)
			linkS = T
		if(4)
			linkE = T
		if(8)
			linkW = T

/turf/proc/setairlink(dir, val)

	switch(dir)
		if(1)
			airN = val
		if(2)
			airS = val
		if(4)
			airE = val
		if(8)
			airW = val

/turf/proc/setcondlink(dir, val)

	switch(dir)
		if(1)
			condN += val
		if(2)
			condS += val
		if(4)
			condE += val
		if(8)
			condW += val

/turf/buildlinks()				// call this one to update a cell and neighbours (on cell state change)
	updatelinks()

	for(var/dir in cardinal)
		var/turf/T = get_step(src,dir)
		if(T)
			T.updatelinks()

/turf/proc/updatelinks()			// this does updating for a single cell

	src.update_again = 1 // initialize atmosphere updates for this turf

	airN = null
	airS = null
	airE = null
	airW = null

	condN = 0
	condS = 0
	condE = 0
	condW = 0

	// originally in turf/Neighbors()

	var/list/NL = cardinal.Copy()

	for(var/obj/machinery/door/window/D in src)
		if(!( D.density ))
			continue

		if (D.dir & 12)
			NL -= SOUTH
			condS = 1
		else
			NL -= EAST
			condE = 1


	for(var/obj/window/D in src)
		if(!( D.density ))
			continue
		NL -= D.dir
		setcondlink(D.dir, 1+D.reinf)

		if (D.dir == SOUTHWEST)
			NL.len = null
			break



	for(var/dir in cardinal)
		var/turf/T = get_step(src, dir)
		setlink(dir,T)


		var/obj/move/O = locate(/obj/move, T)
		if (O)
			setlink(dir, O)
			if (!O.updatecell)
				goto Label_317


		if((!( T ) || !( T.updatecell )) || !(dir in NL))
			goto Label_317

		//L += T
		setairlink(dir, 1)

		var/direct = turn(dir, 180)

		for(var/obj/machinery/door/window/D in T)
			if(!( D.density ))
				goto Label_201

			if (D.dir & 12)
				if((dir & 1))
					//L -= T
					setairlink(dir, null)
					setcondlink(dir, 1)
					goto Label_201
			else
				if(dir & 8)			//was (direct&8)
					setairlink(dir, null)
					setcondlink(dir, 1)
			Label_201:
			//Foreach goto(101)

		for(var/obj/window/D in T)
			if(!( D.density ))
				goto Label_312
			//var/direct = get_dir(T, src)
			if (D.dir == SOUTHWEST)
				//L -= T
				setairlink(dir, null)
				setcondlink(dir, 1+D.reinf)
				goto Label_312
			else
				if(direct == D.dir)
					//L -= T
					setairlink(dir, null)
					setcondlink(dir,1+D.reinf)

			Label_312:

			//Foreach goto(219)

		//*****

		Label_317:
		//Foreach goto(40)


/turf/proc/report()
	return "[src.type] [x] [y] [z]"


// return the total gas contents of a turf

/turf/proc/tot_gas()
	return co2 + oxygen + poison + sl_gas + n2


// return the gas contents of a turf as a gas obj

/turf/proc/get_gas()

	var/obj/substance/gas/tgas = new()

	tgas.oxygen = src.oxygen
	tgas.n2 = src.n2
	tgas.plasma = src.poison
	tgas.co2 = src.co2
	tgas.sl_gas = src.sl_gas
	tgas.temperature = src.temp
	tgas.maximum = CELLSTANDARD		// not actually a maximum

	return tgas



/turf/proc/exchange()
	// the following if-code makes it so that on each tick, no adjacant tiles are updated.
	/*var/update_this = 0
	if(update_state == 0 && src.x % 2 == 0 && src.y % 2 == 0)
		update_this = 1
	if(update_state == 1 && src.x % 2 == 1 && src.y % 2 == 0)
		update_this = 1
	if(update_state == 2 && src.x % 2 == 0 && src.y % 2 == 1)
		update_this = 1
	if(update_state == 3 && src.x % 2 == 1 && src.y % 2 == 1)
		update_this = 1
	if(!update_this) return*/

	src.oldfirelevel = src.firelevel

	var/list/adjacant = list()
	if(airN)
		adjacant+=linkN
	if(airS)
		adjacant+=linkS
	if(airW)
		adjacant+=linkW
	if(airE)
		adjacant+=linkE
	for(var/turf/link in adjacant)
		if(istype(link, /turf/space))
			src.oxygen = src.oxygen / VACUUM_SPEED
			src.poison = src.poison / VACUUM_SPEED
			src.co2 = src.co2 / VACUUM_SPEED
			src.sl_gas = src.sl_gas / VACUUM_SPEED
			src.n2 = src.n2 / VACUUM_SPEED
			src.temp = src.temp / VACUUM_SPEED
			break
		else
			var/oxygen_m	= (src.oxygen - link.oxygen) * 0.5 * EXCHANGE_SPEED
			var/poison_m	= (src.poison - link.poison) * 0.5 * EXCHANGE_SPEED
			var/co2_m		= (src.co2 - link.co2) * 0.5 * EXCHANGE_SPEED
			var/sl_gas_m	= (src.sl_gas - link.sl_gas) * 0.5 * EXCHANGE_SPEED
			var/n2_m		= (src.n2 - link.n2) * 0.5 * EXCHANGE_SPEED
			var/temp_m		= (src.temp - link.temp) * 0.5 * EXCHANGE_SPEED
			src.oxygen	-= oxygen_m
			link.oxygen	+= oxygen_m
			src.poison	-= poison_m
			link.poison	+= poison_m
			src.co2		-= co2_m
			link.co2	+= co2_m
			src.sl_gas	-= sl_gas_m
			link.sl_gas	+= sl_gas_m
			src.n2		-= n2_m
			link.n2		+= n2_m
			src.temp	-= temp_m
			link.temp	+= temp_m
			if (link.oldfirelevel >= 100000.0)
				burn = 1
	compare()

/turf/updatecell()
	if (src.sl_gas > 0)
		src.sl_gas--
	src.overlays = null
	if (src.sl_gas > 101000.0)
		src.overlays.Add( slmaster )
	if (src.poison > 100000.0)
		src.overlays.Add( plmaster )
	if (src:lit != null)
		src.overlays.Add( lit )
	if (oxygen < 1000)
		burn = 0
	if(src.checkfire)
		if (burn)
			src.firelevel = src.oxygen + src.poison
		if (src.firelevel >= 100000.0)
			src.icon_state = "burning"
			sd_SetLuminosity(4)

			src.oxygen = max(src.oxygen - 5000, 0)
			src.poison = max(src.poison - 5000, 0)
			src.co2 += 5000

			if(src.oxygen == 0 || src.poison == 0)
				burn = 0 // make fires stop when they run out of oxygen or plasma
				firelevel = 0
				unburn()

			// heating from fire
			temp += (firelevel/vsc.FIREQUOT+vsc.FIREOFFSET - temp) / vsc.FIRERATE


			if (locate(/obj/effects/water, src))
				src.firelevel = 0
			for(var/atom/movable/A in src)
				A.burn(src.firelevel)
				//Foreach goto(522)
		else
			src.firelevel = 0
			if (src.icon_state == "burning")
				unburn()


	if ((locate(/obj/effects/water, src) || src.firelevel < 100000.0))
		src.firelevel = 0
		//cool due to water
		temp += (T20C - temp) / vsc.FIRERATE
	return

/turf/proc/compare()
	var/differ_at_all = 0
	for(var/turf/T in FindLinkedTurfs())
		var/differ = 0
		if(!update_again && !T.update_again && prob(70))
			return
		else if(round(firelevel, 50000) != round(T.firelevel, 50000))
			differ = 1
		else if(round(oxygen, 50000) != round(T.oxygen, 50000))
			differ = 1
		else if(round(poison, 50000) != round(T.poison, 50000))
			differ = 1
		else if(round(co2, 50000) != round(T.co2, 50000))
			differ = 1
		else if(round(n2, 50000) != round(T.n2, 50000))
			differ = 1
		if(differ)
			if(!T.update_again)
				T.update_again = 1
				//if(locate(/mob/human) in view(src, 2)) world << "updating"
				spawn T.updatecell()
				differ_at_all = 1
		else
			T.update_again = 0
	if(differ_at_all)
		update_again = 1
	else
		update_again = 0

/turf/conduction()

	var/difftemp = 0
	for(var/turf/T in FindCondTurfs())
		var/cond = getCond(get_dir(src, T))
		difftemp += (T.temp-src.temp)/(10*cond)

	temp += difftemp
	//hotcheck()


/turf/proc/FindCondTurfs()

	var/list/L = list(  )
	if(condN)
		L += linkN
	if(condS)
		L += linkS
	if(condE)
		L += linkE
	if(condW)
		L += linkW


	return L

/turf/proc/getCond(dir)
	switch(dir)
		if(1)
			return condN
		if(2)
			return condS
		if(4)
			return condE
		if(8)
			return condW
	return 0