/obj/effects/water/New()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	spawn( 70 )
		del(src)
		return
	return

/obj/effects/water/Del()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	..()
	return

/obj/effects/water/Move(turf/newloc)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	if (--src.life < 1)
		//SN src = null
		del(src)
	if(newloc.density)
		return 0
	.=..()