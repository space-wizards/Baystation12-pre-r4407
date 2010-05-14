/obj/item/weapon/dummy/ex_act()
	return

/obj/item/weapon/dummy/blob_act()
	return

/obj/item/weapon/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
		else
	return

/obj/item/weapon/blob_act()
	return

//*****RM

/obj/item/weapon/verb/move_to_top()
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T


//*****


/obj/item/weapon/proc/attack_self()
	return

/obj/item/weapon/proc/talk_into(mob/M as mob, text)
	return

/obj/item/weapon/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/weapon/proc/dropped(mob/user as mob)
	return

/obj/item/weapon/proc/afterattack()
	return

/obj/item/weapon/examine()
	set src in view()

	var/t
	switch(src.w_class)
		if(1.0)
			t = "tiny"
		if(2.0)
			t = "small"
		if(3.0)
			t = "normal-sized"
		if(4.0)
			t = "bulky"
		if(5.0)
			t = "huge"
		else
	if (usr.clumsy && prob(50)) t = "funny-looking"
	usr << text("This is a []\icon[][]. It is a [] item.", !src.blood ? "" : "bloody ",src, src.name, t)
	..()
	return

/obj/item/weapon/attack_hand(mob/user as mob)
	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		user.u_equip(src)
	if (user.hand)
		user.l_hand = src
	else
		user.r_hand = src
	src.loc = user
	src.layer = 52
	add_fingerprint(user)
	user.UpdateClothing()
	return

/obj/item/weapon/attack_paw(mob/user as mob)

	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		user.u_equip(src)
	if (user.hand)
		user.l_hand = src
	else
		user.r_hand = src
	src.loc = user
	src.layer = 52
	user.UpdateClothing()
	return

/obj/item/weapon/Bump(mob/M as mob)
	spawn( 0 )
		..()
		if (src.throwing)
			src.throwing = 0
			src.density = 0
			if (istype(M, /obj))
				var/obj/O = M
				for(var/mob/B in viewers(M, null))
					B.show_message(text("\red [] has been hit by [].", M, src), 1)
				O.hitby(src)
			if (!( istype(M, /mob) ))
				return
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] has been hit by [].", M, src), 1)
			if (M.health > -100.0)
				if (istype(M, /mob/human))
					var/mob/human/H = M
					var/dam_zone = pick("chest", "diaper", "head")
					if (H.organs[text("[]", dam_zone)])
						var/obj/item/weapon/organ/external/affecting = H.organs[text("[]", dam_zone)]
						if (affecting.take_damage(src.throwforce, 0))
							H.UpdateDamageIcon()
						else
							H.UpdateDamage()
				else
					M.bruteloss += src.throwforce
				M.updatehealth()
		return
	return

/obj/item/weapon/proc/UIinput(C as text)
	return 0
