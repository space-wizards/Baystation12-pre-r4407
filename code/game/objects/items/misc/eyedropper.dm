/obj/item/weapon/dropper/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/dropper/attack_hand()
	..()
	src.update_is()
	return

/obj/item/weapon/dropper/proc/update_is()
	var/t1 = round(src.chem.volume())
	if (istype(src.loc, /mob))
		if (src.mode == "inject")
			src.icon_state = text("dropper_[]_I", t1)
		else
			src.icon_state = text("dropper_[]_d", t1)
	else
		src.icon_state = text("dropper_[]", t1)
	src.s_istate = "dropper"
	return

/obj/item/weapon/dropper/dropped()
	..()
	src.update_is()
	return

/obj/item/weapon/dropper/attack_self()
	if (src.mode == "inject")
		src.mode = "draw"
	else
		src.mode = "inject"
	src.update_is()
	return

/obj/item/weapon/dropper/New()

	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 5
	..()
	return

/obj/item/weapon/dropper/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	if(!src.chem.volume())
		user << "\red The dropper is empty!"
		return
	if (user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has been eyedropped with [] by [].", M, src, user), 1)
		var/amount = src.chem.dropper_mob(M, 1)
		src.update_is()
		user.show_message(text("\red You drop [] units into []'s eyes. The dropper contains [] millimeters.", amount, M, src.chem.volume()))
		src.add_fingerprint(user)
	return