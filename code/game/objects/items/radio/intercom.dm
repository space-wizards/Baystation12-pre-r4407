/obj/item/weapon/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn( 0 )
		attack_self(user)
		return
	return

/obj/item/weapon/radio/intercom/attack_paw(mob/user as mob)

	if ((ticker && ticker.mode.name == "monkey"))
		return src.attack_hand(user)
	return

/obj/item/weapon/radio/intercom/attack_hand(mob/user as mob)

	src.add_fingerprint(user)
	spawn( 0 )
		attack_self(user)
		return
	return

/obj/item/weapon/radio/intercom/send_crackle()

	if (src.listening)
		return list(  )
	return

/obj/item/weapon/radio/intercom/sendm(msg)

	if (src.listening)
		return hearers(7, src.loc)
	return
