/turf/space/New()
 ..()
 sd_SetLuminosity(1)

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/weapon/tile/T as obj, mob/user as mob)
	if (istype(T, /obj/item/weapon/tile))
		T.build(src)
		T.amount--
		T.add_fingerprint(user)
		if (T.amount < 1)
			user.u_equip(T)
			del(T)
			return
	return

/turf/space/Entered(atom/movable/A as mob|obj)
	..()

	if (A.x <= 2 || A.x >= (world.maxx - 1) || A.y <= 2 || A.y >= (world.maxy - 1))
		if(istype(A, /obj/meteor))
			del(A)
			return
		var/new_x = A.x
		var/new_y = A.y
		var/new_z = A.z
		if (A.x <= 2)
			new_x = world.maxx - 2
		else if (A.x >= (world.maxx - 1))
			new_x = 3

		if (A.y <= 2)
			new_y = world.maxy - 2
		else if (A.y >= (world.maxy - 1))
			new_y = 3

		new_z = getZlevel(Z_SPACE)

		A.Move(locate(new_x, new_y, new_z))
