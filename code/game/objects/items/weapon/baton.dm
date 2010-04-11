

/obj/item/weapon/baton/proc/update_icon()
	icon_state = "baton"

/obj/item/weapon/baton/attack_self(mob/user as mob)
	src.status = !( src.status )
	if (usr.clumsy && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.paralysis += 60
		return
	if (src.status)
		user << "\blue The baton is now on."
	else
		user << "\blue The baton is now off."
	src.add_fingerprint(user)
	return

/obj/item/weapon/baton/attack(mob/M as mob, mob/user as mob)
	if (usr.clumsy && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.paralysis += 60
		return
	src.add_fingerprint(user)
	var/mob/human/H = M

	if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if (status == 0 || (status == 1 && charges ==0) || M.zombie)
		if(user.a_intent == "hurt")
			if (M.weakened < 5 && (!M.ishulk))
				M.weakened = 5
				..()
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been beaten with the stun baton by [user]!</B>", 1)
			if(status == 1 && charges == 0 && !M.zombie)
				user << "\red Not enough charge"
			return
		else
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been prodded with the stun baton by [user]! Luckily it was off.</B>", 1)
			if(status == 1 && charges == 0)
				if(M.zombie)
					user << "\red You can not stun zombies!"
				else
					user << "\red Not enough charge"
			return
	if(charges > 0 && status == 1)
		flick("baton_active", src)
		if (user.a_intent == "hurt")
			charges--
			if (M.weakened < 5 && (!M.ishulk))
				M.weakened = 5
			if (M.stuttering < 5 && (!M.ishulk))
				M.stuttering = 5
			..()
			if (M.stunned < 7 && (!M.ishulk))
				M.stunned = 7
		else
			charges--
			if (M.weakened < 20 && (!M.ishulk))
				M.weakened = 20
			if (M.stuttering < 20 && (!M.ishulk))
				M.stuttering = 20
			if (M.stunned < 20 && (!M.ishulk))
				M.stunned = 20
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the stun baton by [user]!</B>", 1, "\red You hear someone fall", 2)
