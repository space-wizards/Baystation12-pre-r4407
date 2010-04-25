turf/proc
	tot_gas()
		if(zone)
			return zone.per_turf()
		else
			return 0



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
/*
/obj/move/proc/FindTurfs()
	var/list/L = list(  )
	for(var/dir in src.Neighbors())
		var/turf/T = get_step(src.loc, dir)


		//++++++

		if(!( T ))
			goto Label_299
		L += T
		var/direct = turn(dir, 180)*/
		//*****RM as 4.1beta
/*
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
*/
		//*****
/*
		Label_299:
		if ((locate(/obj/move, T) && T in L))
			L -= T
			var/obj/move/O = locate(/obj/move, T)
			if (O.updatecell)
				L += O
		else
			if ((isturf(T) && !( T.updatecell )))
				L -= T

	return L*/


/obj/move/proc/tot_gas()
	return CELLSTANDARD

/obj/move/proc/process()
	return
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
		temp += (T20C - temp) / FIRERATE



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
	/*
	src.tmpoxy = src.oxygen
	src.oldoxy = src.oxygen
	src.tmppoison = src.poison
	src.oldpoison = src.poison
	src.tmpco2 = src.co2
	src.oldco2 = src.co2
	src.tn2 = src.n2
	src.on2 = src.n2

	otemp = temp
	ttemp = temp*/
	..()
	return

/turf/proc/res_vars()
	update_again = 1
	return

/turf/proc/unburn()
	return
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


/*turf/proc/Neighbors()

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
	return L*/


/*
/proc/flipdir(dir)

	switch(dir)
		if(1)
			return 2
		if(2)
			return 1
		if(4)
			return 8
		if(8)
			return 4
		if(5)
			return 10
		if(6)
			return 9
		if(9)
			return 10
		if(10)
			return 9
		else
			return 0

*/

/turf/proc/report()
	return "[src.type] [x] [y] [z]"


// return the total gas contents of a turf


// return the gas contents of a turf as a gas obj

/turf/proc/get_gas()

	var/obj/substance/gas/tgas = new()

	tgas.oxygen = src.oxygen()
	tgas.n2 = src.n2()
	tgas.plasma = src.poison()
	tgas.co2 = src.co2()
	tgas.sl_gas = src.sl_gas()
	tgas.temperature = src.temp
	tgas.maximum = CELLSTANDARD		// not actually a maximum

	return tgas