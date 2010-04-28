/obj/watertank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/extinguisher))
		W:waterleft = 20
		W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:waterleft)
		user << "\blue Extinguisher refueled"
	else if (istype(W, /obj/item/weapon/cleaner))
		W:water = 8
		W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:water)
		user << "\blue Cleaner refilled"
	else if (istype(W, /obj/item/weapon/bucket))
		W:water = 20
		W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:water)
		user << "\blue Bucket filled"
		return
	else if (istype(W,/obj/item/weapon/food/waterbottle))
		W:ammount = 5
		W:updateicon()
		user << "\blue Bottle refilled"
/obj/watertank/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effects/water(src.loc)
				del(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effects/water(src.loc)
				del(src)
				return
		else
	return

/obj/watertank/blob_act()
	if(prob(25))
		new /obj/effects/water(src.loc)
		del(src)