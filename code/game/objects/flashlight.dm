/obj/item/weapon/flashlight/attack_self(mob/user)
	on = !on
	icon_state = "flight[on]"

	if (on)
		src.process()

/obj/item/weapon/flashlight/attack_hand(mob/user as mob)
	var/atom/holder = loc
	if (isturf(holder))
		sd_SetLuminosity(0)
		if (on)
			user:sd_SetLuminosity(5)
	..()

/obj/item/weapon/flashlight/proc/process()
	lastHolder = null

	while (on)
		var/atom/holder = loc
		var/isHeld = 0

		if (ismob(holder))
			isHeld = 1
			if (lastHolder == null)
				sd_SetLuminosity(0)
		else
			isHeld = 0
			if (lastHolder != null)
				lastHolder:sd_SetLuminosity(0)
				lastHolder = null
				sd_SetLuminosity(5)

		if (isHeld == 1)
			if (holder != lastHolder && lastHolder != null)
				lastHolder:sd_SetLuminosity(0)
			holder:sd_SetLuminosity(5)
			lastHolder = holder
		sleep(10)

	if (lastHolder != null)
		lastHolder:sd_SetLuminosity(0)
		lastHolder = null

	sd_SetLuminosity(0)
