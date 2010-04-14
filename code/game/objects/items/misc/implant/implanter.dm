/obj/item/weapon/implanter/proc/update()

	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

/obj/item/weapon/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return

	if (user && src.imp)
		for (var/mob/O in viewers(M, null))
			O.show_message("\red [M] has been implanted by [user].", 1)

		src.imp.loc = M
		src.imp.implanted = 1
		src.imp.implanted(M)
		src.imp = null
		user.show_message("\red You implanted the implant into [M].")
		src.icon_state = "implanter0"
