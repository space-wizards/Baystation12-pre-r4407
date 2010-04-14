
/obj/item/weapon/sword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/sword/attack_self(mob/user as mob)
	if (user.clumsy && prob(50))
		user << "\red You accidentally cut yourself with the Sword."
		user.bruteloss += 5
		user.fireloss +=5
	src.active = !( src.active )
	if (src.active)
		user << "\blue The sword is now active."
		src.force = 40
		src.icon_state = "sword1"
		src.w_class = 4
	else
		user << "\blue The sword can now be concealed."
		src.force = 3
		src.icon_state = "sword0"
		src.w_class = 2
	src.add_fingerprint(user)
	return