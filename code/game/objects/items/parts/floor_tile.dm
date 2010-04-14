/obj/item/weapon/tile/New()

	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)
	return

/obj/item/weapon/tile/attack_hand(mob/user as mob)

	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/tile/F = new /obj/item/weapon/tile( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 52
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/tile/proc/build(turf/S as turf)
	var/turf/station/floor/W = S.ReplaceWithFloor()

	W.burnt = 1
	W.intact = 0
	W.buildlinks()
	W.levelupdate()
	W.icon_state = "Floor1"
	W.health = 100
	return

/obj/item/weapon/tile/attack_self(mob/user as mob)

	if (usr.stat)
		return
	var/T = user.loc
	if (!( istype(T, /turf) ))
		user << "\blue You must be on the ground!"
		return
	else
		var/S = T
		if (!( istype(S, /turf/space) ))
			user << "You cannot build on or repair this turf!"
			return
		else
			src.build(S)
			src.amount--
	if (src.amount < 1)
		user.u_equip(src)
		//SN src = null
		del(src)
		return
	src.add_fingerprint(user)
	return

/obj/item/weapon/tile/attackby(obj/item/weapon/tile/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/tile) ))
		return
	if (W.amount == 10)
		return
	W.add_fingerprint(user)
	if (W.amount + src.amount > 10)
		src.amount = W.amount + src.amount - 10
		W.amount = 10
	else
		W.amount += src.amount
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/tile/examine()
	set src in view(1)

	..()
	usr << text("There are [] tile\s left on the stack.", src.amount)
	return