/obj/item/weapon/storage/toolbox/New()

	new /obj/item/weapon/screwdriver( src )
	new /obj/item/weapon/wrench( src )
	new /obj/item/weapon/weldingtool( src )
	new /obj/item/weapon/radio( src )
	new /obj/item/weapon/analyzer( src )
	new /obj/item/weapon/extinguisher( src )
	new /obj/item/weapon/wirecutters( src )
	..()
	return

/obj/item/weapon/storage/toolbox/electrical/New()
	..()
	src.contents = null
	new /obj/item/weapon/screwdriver( src )
	new /obj/item/weapon/wirecutters( src )
	new /obj/item/weapon/t_scanner( src )
	new /obj/item/weapon/crowbar( src )
	new /obj/item/weapon/cable_coil( src )
	new /obj/item/weapon/cable_coil( src )
	new /obj/item/weapon/cable_coil( src )

	return

/obj/item/weapon/storage/toolbox/attack(mob/M as mob, mob/user as mob)
	..()
	if (usr.clumsy && prob(50))
		usr << "\red The toolbox slips out of your hand and hits your head."
		usr.bruteloss += 10
		usr.paralysis += 20
		return
	if (M.stat < 2 && prob(15))
		var/mob/H = M
		// ******* Check
		if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(5, 60)
		if (prob(75))
			if (M.paralysis < time && (!M.ishulk))
				M.paralysis = time
		else
			if (M.stunned < time && (!M.ishulk))
				M.stunned = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall.", 2)
	else
		M << text("\red [] tried to knock you unconcious!",user)
		M.eye_blurry += 3
		//M.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
	return