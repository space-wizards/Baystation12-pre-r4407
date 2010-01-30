/obj/mopbucket/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/mop))
		if (src.water >= 2)
			src.water -= 2
			W:wet = 2
			W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:wet)
			user << "\blue You wet the mop"
			if (src.chloro != 0)
				W:chloro = src.chloro
		if (src.water < 1)
			user << "\blue Out of water!"
	else if (istype(W, /obj/item/weapon/bucket))
		if ((W:water == 20))
			src.water = 20
			W:water -=20
			W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:water)
			user << "\blue You pour the water into the mop bucket"
	else if (istype(W, /obj/item/weapon/chem/beaker) && src.water >= 2)
		if (src.chloro > 5)
			user << "The bucket is at it's maximum solute of chloroform."
			return
		if (W:chem.chemicals.Find("chloroform") && W:chem.chemicals.len == 1)
			var/obj/item/weapon/chem/beaker/V = W
			var/obj/substance/chemical/S = V:chem.split(20)
			if (S:volume() >= 20)
				user << "\blue You pour the chloroform into the bucket."
				src.chloro += 1
				del (V)
				if (W)
					del (W)
				return
	return

/obj/item/weapon/cleaner/attack(mob/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/cleaner/afterattack(atom/A as mob|obj, mob/user as mob)
	if (src.water < 1)
		user << "\blue Add more water!"
		return
	if (istype(A, /mob/human))
		var/mob/human/M = A
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []'s hands</B>", user, M), 1)
			sleep(40)
			src.water -= 1
			if (M.gloves)
				M.gloves.clean_blood()
			else
				M.clean_blood()
	else if (istype(A, /obj/item/weapon))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
			sleep(40)
			src.water -= 1
			A.clean_blood()
	return

/obj/item/weapon/cleaner/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/mopbucket/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/item/weapon/mop/attack(mob/human/M as mob, mob/user as mob)
	..()
	if (usr.clumsy && prob(50))
		usr << "\red The mop slips out of your hand and hits your head."
		usr.bruteloss += 10
		usr.paralysis += 20
		return
	if (M.alive() && prob(15))
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
		if(M.alive() != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall.", 2)
	else
		M << text("\red [] tried to knock you unconcious!",user)
		M.eye_blurry += 3
		//M.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
	return

/obj/item/weapon/mop/afterattack(atom/A as turf|area, mob/user as mob)
	if (src.wet < 1)
		user << "\blue Your mop is dry!"
		return
	if (istype(A, /turf/station))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			A:wet = 1
			A:chloro = src.chloro
			A.clean_blood()
			A:process()
	if (istype(A, /turf/station/wall) && A.blood)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			A.icon_state = "wall"
			A.blood = ""
	else if ((istype(A, /obj/bloodtemplate)) || (istype(A, /turf/station)))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		var/turf/U = A.loc
		sleep(10)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			U:wet = 1
			del(A)
			U:process()
	return

/turf/station/proc/process()
	while (src.wet == 1)
		src.icon += rgb(0,0,50)
		sleep(800)
		src.icon -= rgb(0,0,50)
		src.wet = 0
		if (src.chloro != 0)
			src.chloro = 0
	return

/obj/item/weapon/shamwow/afterattack(atom/A as turf|area, mob/user as mob)
	if (istype(A, /turf/station))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to dry []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(10)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			A:wet = 0
			A:process()
	return