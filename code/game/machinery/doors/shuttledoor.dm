/obj/shuttle/door/attackby(obj/item/I as obj, mob/user as mob)
	if (src.operating)
		return
	if (src.density)
		return open()
	else
		return close()

/obj/shuttle/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/shuttle/door/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/shuttle/door/attack_hand(mob/user as mob)
	return attackby(user, user)

/obj/shuttle/door/proc/open()
	src.add_fingerprint(usr)
	if (src.operating)
		return
	src.operating = 1
	flick("doorc0", src)
	src.icon_state = "door0"
	sleep(15)

	src.density = 0
	sd_SetOpacity(0)
	src.operating = 0
	src.loc.buildlinks()
	return

/obj/shuttle/door/proc/close()
	src.add_fingerprint(usr)
	if (src.operating)
		return
	src.operating = 1
	flick("doorc1", src)
	src.icon_state = "door1"
	src.density = 1
	if (src.visible)
		sd_SetOpacity(1)
	sleep(15)

	src.operating = 0
	src.loc.buildlinks()
	return

