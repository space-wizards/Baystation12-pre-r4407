/obj/d_girders/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/sheet/metal) && isturf(src.loc) && !istype(src.loc, /turf/space))
		if (W:amount < 1)
			del(W)
			return
		var/FloorIcon = src.loc:icon
		var/FloorState = src.loc:icon_state
		var/FloorIntact = src.loc:intact
		var/FloorHealth = src.loc:health
		var/FloorBurnt = src.loc:burnt
		var/FloorName = src.loc:name

		new /turf/station/wall/false_wall(src.loc)
		var/turf/station/wall/false_wall/FW = src.loc
		FW.setFloorUnderlay(FloorIcon, FloorState, FloorIntact, FloorHealth, FloorBurnt, FloorName)
		W:amount--
		if (W:amount < 1)
			del(W)
		user << "\blue Keep in mind when you open it that it MAY be difficult to slide at first so keep trying."
		del(src)
		return
	else if (istype(W, /obj/item/weapon/sheet/r_metal) && isturf(src.loc) && !istype(src.loc, /turf/space))
		user << "\blue Now constructing reinforced false wall."
		sleep(100)
		del(W)
		var/FloorIcon = src.loc:icon
		var/FloorState = src.loc:icon_state
		var/FloorIntact = src.loc:intact
		var/FloorHealth = src.loc:health
		var/FloorBurnt = src.loc:burnt
		var/FloorName = src.loc:name

		new /turf/station/wall/false_rwall(src.loc)
		var/turf/station/wall/false_rwall/FRW = src.loc
		FRW.setFloorUnderlay(FloorIcon, FloorState, FloorIntact, FloorHealth, FloorBurnt, FloorName)
		user << "\blue Keep in mind when you open it that it MAY be difficult to slide at first so keep trying."
		del(src)
		return
	else if (istype(W, /obj/item/weapon/screwdriver))
		new /obj/item/weapon/sheet/metal( src.loc )
		del(src)
		return
	else
		return ..()