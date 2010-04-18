/obj/item/weapon/gun/energy/taser_gun/update_icon()
	src.icon = initial(src.icon)
	src.icon_state = "t_gun[src.charges]"
	..()

/obj/item/weapon/gun/energy/taser_gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(flag)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	src.add_fingerprint(user)
	if(src.charges < 1)
		user << "\red *click* *click*";
		user.hear_sound("sound/weapon/taser/empty.wav",6)
		return

	src.charges--
	update_icon()
	user.hear_sound("sound/weapon/taser/fire.wav",8)

	var/turf/T = user.loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		user.las_act(1)
		return
	if(!istype(U, /turf))
		return
	world.log_Mattack(text("[user]([user.key])has shot a taser round at [target]"))
	var/obj/bullet/electrode/A = new /obj/bullet/electrode(user.loc)

	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x

	A.process()

/obj/item/weapon/gun/energy/taser_gun/attack(mob/M as mob, mob/user as mob)
	if (usr.clumsy && prob(50))
		usr << "\red The taser gun discharges in your hand."
		usr.paralysis += 60
		return
		var/QQ = rand(1,3)
		if (!src.custom_sound)
			if (src.material == 1)
				user.hear_sound("sound/weapon/generic/hit[QQ].wav",6)
	src.add_fingerprint(user)
	var/mob/human/H = M
	if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if(src.charges >= 1)
		if (user.a_intent == "hurt")
			if (prob(20))
				if (M.paralysis < 10 && (!M.ishulk))
					M.paralysis = 10
			else if (M.weakened < 10 && (!M.ishulk))
				M.weakened = 10
			if (M.stuttering < 10 && (!M.ishulk))
				M.stuttering = 10
			..()
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				O.show_message("\red <B>[M] has been knocked unconscious!</B>", 1, "\red You hear someone fall", 2)
		else
			if (prob(50))
				if (M.paralysis < 60 && (!M.ishulk))
					M.paralysis = 60
			else
				if (M.weakened < 60 && (!M.ishulk))
					M.weakened = 60
			if (M.stuttering < 60 && (!M.ishulk))
				M.stuttering = 60
			if(M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message("\red <B>[M] has been stunned with the taser gun by [user]!</B>", 1, "\red You hear someone fall", 2)
		src.charges--
		update_icon()
	else // no charges in the gun, so they just wallop the target with it
		..()