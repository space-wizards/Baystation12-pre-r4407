/obj/item/weapon/gift/attack_self(mob/user as mob)
	if(!src.gift)
		user << "\blue The gift was empty!"
		del(src)
	src.gift.loc = user
	if (user.hand)
		user.l_hand = src.gift
	else
		user.r_hand = src.gift
	src.gift.layer = 52
	src.gift.add_fingerprint(user)
	del(src)
	return

/obj/item/weapon/a_gift/ex_act()
	del(src)
	return

/obj/item/weapon/a_gift/burn(fi_amount)
	if (fi_amount > 900000.0)
		del(src)
		return
	return

/obj/item/weapon/a_gift/attack_self(mob/M as mob)
	switch(pick("pill", "flash", "t_gun", "l_gun", "shield", "sword", "axe"))
		if("pill")
			var/obj/item/weapon/m_pill/superpill/W = new /obj/item/weapon/m_pill/superpill( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("flash")
			var/obj/item/weapon/flash/W = new /obj/item/weapon/flash( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("l_gun")
			var/obj/item/weapon/gun/energy/laser_gun/W = new /obj/item/weapon/gun/energy/laser_gun( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("t_gun")
			var/obj/item/weapon/gun/energy/taser_gun/W = new /obj/item/weapon/gun/energy/taser_gun( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("shield")
			var/obj/item/weapon/shield/W = new /obj/item/weapon/shield( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("sword")
			var/obj/item/weapon/sword/W = new /obj/item/weapon/sword( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("axe")
			var/obj/item/weapon/axe/W = new /obj/item/weapon/axe( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 52
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		else
	return