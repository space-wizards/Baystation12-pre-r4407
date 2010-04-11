

/obj/item/weapon/m_pill/proc/ingest(mob/M as mob)
	src.amount--
	if (src.amount <= 0)
		del(src)
		return
	return

/obj/item/weapon/m_pill/attack_hand(mob/user as mob)
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/m_pill/F = new src.type( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 52
		F.add_fingerprint(user)
		if (src.amount < 1)
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/m_pill/attack(mob/M as mob, mob/user as mob)
	var/mob/human/H = M
	if (istype(M, /mob/human) && ((H.head && H.head.flags & HEADCOVERSMOUTH) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH)))
		user << "\blue You're going to have to remove that mask/helmet first."
		return

	if ((user != M && istype(M, /mob/human)))
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] is forcing [] to swallow the []", user, M, src), 1)
		var/obj/equip_e/human/O = new /obj/equip_e/human(  )
		O.source = user
		O.target = M
		O.item = src
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "pill"
		M.requests += O
		spawn( 0 )
			O.process()
			return
	else
		src.add_fingerprint(user)
		ingest(M)
	return

/obj/item/weapon/m_pill/examine()
	set src in view(1)
	..()
	usr << text("\blue There are [] pills left on the stack!", src.amount)
	return

/obj/item/weapon/m_pill/attackby(obj/item/weapon/m_pill/W as obj, mob/user as mob)

	if (!( istype(W, src.type) ))
		return
	if (W.amount == 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += W.amount
		del(src)
		return
	return