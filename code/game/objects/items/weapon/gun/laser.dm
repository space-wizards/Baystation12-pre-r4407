/obj/item/weapon/gun/energy/laser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (usr.clumsy && prob(50))
		usr << "\red The laser gun blows up in your face."
		usr.fireloss += 20
		usr.drop_item()
		del(src)
		return
	if (flag)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	src.add_fingerprint(user)

	if(src.charges < 1)
		user << "\red *click* *click*"
		user.hear_sound("sound/weapon/laser/empty.wav",6)

		return

	src.charges--
	update_icon()
	user.hear_sound("sound/weapon/laser/fire.wav",10)

	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U, /turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if(U == T)
		user.las_act()
		return
	if(!istype(U, /turf))
		return

	var/obj/beam/a_laser/A = new /obj/beam/a_laser( user.loc )
	world.log_Mattack(text("[user]([user.key])has shot a taser round at [target]"))
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	user.next_move = world.time + 4
	A.process()
	return

/obj/item/weapon/gun/energy/laser_gun/attack(mob/M as mob, mob/user as mob)
	..()
	src.add_fingerprint(user)
	if ((prob(30) && M.stat < 2))
		var/mob/human/H = M

// ******* Check
		var/QQ = rand(1,3)
		if (!src.custom_sound)
			if (src.material == 1)
				user.hear_sound("sound/weapon/generic/hit[QQ].wav",6)
		if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.weakened < time)
				M.weakened = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			if(O.client)	O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall", 2)
		M.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
	return
