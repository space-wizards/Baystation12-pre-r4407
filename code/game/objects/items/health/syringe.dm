/obj/item/weapon/syringe/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/syringe/attack_hand()
	..()
	src.update_is()
	return

/obj/item/weapon/syringe/proc/update_is()
	var/t1 = round(src.chem.volume(), 5)
	if (istype(src.loc, /mob))
		if (src.mode == "inject")
			src.icon_state = text("syringe_[]_I", t1)
		else
			src.icon_state = text("syringe_[]_d", t1)
	else
		src.icon_state = text("syringe_[]", t1)
	src.s_istate = text("syringe_[]", t1)
	return

/obj/item/weapon/syringe/proc/inject(mob/M as mob)
	var/amount = 5
	var/volume = src.chem.volume()
	if (volume < 0.01)
		return
	else
		if (volume < 5.01)
			amount = volume - 0.01
	amount = src.chem.transfer_mob(M, amount)
	src.update_is()
	return amount

/obj/item/weapon/syringe/dropped()
	..()
	src.update_is()
	return

/obj/item/weapon/syringe/attack_self()
	if (src.mode == "inject")
		src.mode = "draw"
	else
		src.mode = "inject"
	src.update_is()
	return

/obj/item/weapon/syringe/New()
	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 15
	..()
	return

/obj/item/weapon/syringe/attack(mob/M as mob, mob/user as mob)
	if(usr.clumsy && prob(50))
		usr << "\red You accidentally hurt yourself with the Syringe."
		usr.bruteloss += 5
	if (!istype(M, /mob))
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	if (!src.chem.volume())
		user << "\red The syringe is empty!"
		return
	if (user)
		if (istype(M, /mob/human))
			var/obj/equip_e/human/O = new /obj/equip_e/human(  )
			O.source = user
			O.target = M
			O.item = src
			O.s_loc = user.loc
			O.t_loc = M.loc
			O.place = "syringe"
			M.requests += O
			spawn( 0 )
				O.process()
				return
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] has been injected with [] by [].", M, src, user), 1)
				//Foreach goto(192)
			var/amount = src.chem.transfer_mob(M, 5)
			src.update_is()

			user.show_message(text("\red You inject [] units into the []. The syringe contains [] millimeters.", amount, M, src.chem.volume()))
	return