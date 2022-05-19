/obj/item/weapon/paint/attack_self(mob/user as mob)

	var/t1 = input(user, "Please select a color:", "Locking Computer", null) in list( "red", "blue", "green", "yellow", "black", "white", "neutral" )
	if ((user.equipped() != src || user.stat || user.restrained()))
		return
	src._color = t1
	src.icon_state = text("paint_[]", t1)
	add_fingerprint(user)
	return