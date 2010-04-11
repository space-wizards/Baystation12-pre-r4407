/obj/item/weapon/ointment/attack_hand(mob/user as mob)
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/ointment/F = new /obj/item/weapon/ointment( user )
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

/obj/item/weapon/ointment/attack(mob/M as mob, mob/user as mob)

	if (M.health < 0)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if (user)
		for(var/mob/O in viewers(M, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red [] has been applied with [] by []", M, src, user), 1)
			//Foreach goto(89)
	if (istype(M, /mob/human))
		var/mob/human/H = M
		var/obj/item/weapon/organ/external/affecting = H.organs["chest"]
		if (istype(user, /mob/human))
			var/mob/user2 = user
			var/t = user2.zone_sel.selecting
			if ((t in list( "hair", "eyes", "mouth", "neck" )))
				t = "head"
			if (H.organs[text("[]", t)])
				affecting = H.organs[text("[]", t)]
		else
			if ((!( istype(affecting, /obj/item/weapon/organ/external) ) || affecting.burn_dam <= 0))
				affecting = H.organs["head"]
				if ((!( istype(affecting, /obj/item/weapon/organ/external) ) || affecting.burn_dam <= 0))
					affecting = H.organs["diaper"]
		if (affecting.heal_damage(0, 40))
			H.UpdateDamageIcon()
		else
			H.UpdateDamage()
	src.amount--
	if (src.amount <= 0)
		//SN src = null
		del(src)
		return
	return

/obj/item/weapon/ointment/examine()
	set src in view(1)

	usr << text("\blue there are [] ointment pack\s left on the stack!", src.amount)
	return

/obj/item/weapon/ointment/attackby(obj/item/weapon/ointment/W as obj, mob/user as mob)

	if (!( istype(W, /obj/item/weapon/ointment) ))
		return
	if (W.amount == 5)
		return
	if (W.amount + src.amount > 5)
		src.amount = W.amount + src.amount - 5
		W.amount = 5
	else
		W.amount += W.amount
		//SN src = null
		del(src)
		return
	return