
/obj/item/weapon/pen/sleepypen/attack_paw(mob/user as mob)

	return src.attack_hand(user)
	return

/obj/item/weapon/pen/sleepypen/New()

	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 5
	var/datum/chemical/s_tox/C = new /datum/chemical/s_tox( null )
	C.moles = C.density * 5 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	..()
	return

/obj/item/weapon/pen/sleepypen/attack(mob/M as mob, mob/user as mob)

	if (!( istype(M, /mob) ))
		return
	if (src.desc == "It's a normal black ink pen.")
		return ..()
	if (user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has been stabbed with [] by [].", M, src, user), 1)
			//Foreach goto(57)
		var/amount = src.chem.transfer_mob(M, src.chem.maximum)
		user.show_message(text("\red You inject [] units into the [].", amount, M))
		src.desc = "It's a normal black ink pen."
	return