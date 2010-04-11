
/obj/item/weapon/axe/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The axe is now energised."
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 4
	else
		user << "\blue The axe can now be concealed."
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 2
	src.add_fingerprint(user)
	return
