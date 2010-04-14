/obj/item/weapon/gun/revolver/examine()
	set src in usr

	src.desc = text("There are [] bullet\s left! Uses 357.", src.bullets)
	..()
	return

/obj/item/weapon/gun/revolver/attackby(obj/item/weapon/ammo/a357/A as obj, mob/user as mob)

	if (istype(A, /obj/item/weapon/ammo/a357))
		if (src.bullets >= 7)
			user << "\blue It's already fully loaded!"
			return 1
		if (A.amount_left <= 0)
			user << "\red There is no more bullets!"
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			user << text("\red You reload [] bullet\s!", A.amount_left)
			src.hear_sound("sound/weapon/revolver/reload.wav",6)
			A.amount_left = 0
		else
			user << text("\red You reload [] bullet\s!", 7 - src.bullets)
			src.hear_sound("sound/weapon/revolver/reload.wav",6)
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_icon()
		return 1
	return

/obj/item/weapon/gun/revolver/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message("\red *click* *click*", 2)
		user.hear_sound("sound/weapon/revolver/empty.wav",6)
		return
	src.bullets--
	for(var/mob/O in hearers(user, null))
		O.show_message(text("\red <B>[] fires a revolver at []!</B>", user, target), 1, "\red You hear a gunshot", 2)
		user.hear_sound("sound/weapon/revolver/fire.wav",13)
	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return
	if (U == T)
		user.las_act("bullet")
		return
	var/obj/bullet/A = new /obj/bullet( user.loc )
	if (!istype(U, /turf))
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	user.next_move = world.time + 4
	spawn( 0 )
		A.process()
		return
	return

/obj/item/weapon/gun/revolver/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)
	var/mob/human/H = M

// ******* Check
	var/QQ = rand(1,3)
	if (!src.custom_sound)
		if (src.material == 1)
			user.hear_sound("sound/weapon/generic/hit[QQ].wav",6)
	if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if ((user.a_intent == "hurt" && src.bullets > 0))
		if (prob(20))
			if (M.paralysis < 10)
				M.paralysis = 10
		else
			if (M.weakened < 10)
				M.weakened = 10
		src.bullets--
		src.force = 90
		..()
		src.force = 60
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been shot point-blank by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	else
		if (prob(50))
			if (M.paralysis < 60)
				M.paralysis = 60
		else
			if (M.weakened < 60)
				M.weakened = 60
		src.force = 30
		..()
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if (O.client)	O.show_message(text("\red <B>[] has been pistol whipped by []!</B>", M, user), 1, "\red You hear someone fall", 2)
	return
