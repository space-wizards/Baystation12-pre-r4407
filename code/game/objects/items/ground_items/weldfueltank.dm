/obj/weldfueltank/meteorhit(obj/O as obj)
	var/turf/T = src.loc
	T.poison += 1600000
	T.oxygen += 1600000
	if(T.firelevel < 900000.0)
		T.firelevel = T.poison
	del(src)

/obj/weldfueltank/attackby(obj/item/weapon/weldingtool/W as obj, mob/user as mob)
	if (!( istype(W, /obj/item/weapon/weldingtool) ))
		return
	W.weldfuel = 20
	W.suffix = text("[][]", (W == src ? "equipped " : ""), W.weldfuel)
	user << "\blue Welder refueled"
	return

/obj/weldfueltank/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if(prob(25))
				var/turf/T = src.loc
				T.poison += 1600000
				T.oxygen += 1600000
			del(src)
		if(3.0)
			if(prob(5))
				var/turf/T = src.loc
				T.poison += 1600000
				T.oxygen += 1600000
				del(src)
				return
		else
	return