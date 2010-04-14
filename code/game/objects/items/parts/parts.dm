/obj/item/weapon/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		//SN src = null
		del(src)


/obj/item/weapon/table_parts/attack_self(mob/user as mob)
	var/state = input(user, "What type of table?", "Assembling Table", null) in list( "sides", "corners", "alone" )
	var/direct = SOUTH
	if (state == "corners")
		direct = input(user, "Direction?", "Assembling Table", null) in list( "northwest", "northeast", "southwest", "southeast" )
	else
		if (state == "sides")
			direct = input(user, "Direction?", "Assembling Table", null) in list( "north", "east", "south", "west" )
	var/obj/table/T = new /obj/table( user.loc )
	T.icon_state = state
	T.dir = text2dir(direct)
	T.add_fingerprint(user)
	del(src)
	return

/obj/item/weapon/rack_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/sheet/metal( src.loc )
		del(src)
		return
	return

/obj/item/weapon/rack_parts/attack_self(mob/user as mob)
	var/obj/rack/R = new /obj/rack( user.loc )
	R.add_fingerprint(user)
	del(src)
	return
