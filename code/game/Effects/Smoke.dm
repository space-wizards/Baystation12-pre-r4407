
/obj/effects/smoke/proc/Life()
	if (src.amount > 1)
		var/obj/effects/smoke/W = new src.type( src.loc )
		W.amount = src.amount - 1
		W.dir = src.dir
		spawn( 0 )
			W.Life()
			return
	src.amount--
	if (src.amount <= 0)
		sleep(50)
		//SN src = null
		del(src)
		return
	var/turf/T = get_step(src, turn(src.dir, pick(90, 0, 0, -90.0)))
	if ((T && T.density))
		src.dir = turn(src.dir, pick(-90.0, 90))
	else
		step_to(src, T, null)
		T = src.loc
		if (istype(T, /turf))
			T.firelevel = T.poison
	spawn( 3 )
		src.Life()
		return
	return