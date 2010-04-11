/obj/item/weapon/pen/zombiepen/attack(mob/M as mob, mob/user as mob)

	if (!( istype(M, /mob) ))
		return
	if (used)
		return
	if (src.desc == "It's a normal black ink pen.")
		return ..()
	if (user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has been stabbed with [] by [].", M, src, user), 1)

		user.show_message(text("\red You inject units into the [].",M))
		M.traitor_infect()
		used = 1
		src.desc = "It's a normal black ink pen."
	return