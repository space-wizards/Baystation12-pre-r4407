/obj/rack/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.icon_state = "rackbroken"
				src.density = 0
		else
	return

/obj/rack/blob_act()
	if(prob(50))
		del(src)
		return
	else if(prob(50))
		src.icon_state = "rackbroken"
		src.density = 0
		return

/obj/rack/CheckPass(atom/movable/O as mob|obj, target as turf)
	if (O.flags & 2)
		return 1
	else
		return 0
	return

/obj/rack/MouseDrop_T(obj/O as obj, mob/user as mob)
	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/rack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(user.zombie)
		new /obj/item/weapon/rack_parts( src.loc )
		//SN src = null
		del(src)
		return
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/rack_parts( src.loc )
		//SN src = null
		del(src)
		return
	user.drop_item()
	if(W && W.loc)	W.loc = src.loc
	return

/obj/rack/meteorhit(obj/O as obj)
	if(prob(75))
		del(src)
		return
	else
		src.icon_state = "rackbroken"
		src.density = 0
	return
