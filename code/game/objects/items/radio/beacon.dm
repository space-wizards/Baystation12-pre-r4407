/obj/item/weapon/radio/beacon/hear_talk()
	return

/obj/item/weapon/radio/beacon/sendm()
	return null

/obj/item/weapon/radio/beacon/send_crackle()
	return null

/obj/item/weapon/radio/beacon/verb/alter_signal(t as text)
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return