/obj/item/weapon/cane/attack_self(mob/user as mob)
	if (istype(user:head,/obj/item/weapon/clothing/head/that) && istype(user:glasses,/obj/item/weapon/clothing/glasses/monocle) && istype(user:wear_suit,/obj/item/weapon/clothing/suit/wcoat))
		if (src.flaming)
			user << "Glowing cane deactivated!"
			src.flaming = 0
			src.s_istate = "cane"
			src.icon_state = "cane"
			return
		if (!src.flaming)
			user << "Glowing cane activated!"
			src.flaming = 1
			src.s_istate = "flamingcane"
			src.icon_state = "flamingcane"
			return

/obj/item/weapon/cane/afterattack(mob/M as mob, mob/user as mob)
	if (!src.flaming)
		..()
		return
	var/obj/item/weapon/organ/external/A = M.contents["r_arm"]
	var/obj/item/weapon/organ/external/B = M.contents["l_arm"]
	var/obj/item/weapon/organ/external/C = M.contents["r_leg"]
	var/obj/item/weapon/organ/external/D = M.contents["l_leg"]

	if (src.flaming && prob(50))
		var/S = pick(1,2,3,4,5)
		var/G = pick(1,2,3,4)
		src.hear_sound("sound/weapon/cane/crit/hit[S]",6)
		switch(G)
			if (1)
				if (A.broken)
					return
				user << "Your flaming cane strikes down on their right arm, breaking it."
				M << "Your right arm is stricken by the flaming cane and shattered."
				A.broken = 1
			if (2)
				if (B.broken)
					return
				user << "Your flaming cane strikes down on their left arm, breaking it."
				M << "Your left arm is stricken by the flaming cane and shattered."
				B.broken = 1
			if (3)
				if (C.broken)
					return
				user << "Your flaming cane strikes down on their right leg, breaking it."
				M << "Your right leg is stricken by the flaming cane and shattered."
				C.broken = 1
			if (4)
				if (D.broken)
					return
				user << "Your flaming cane strikes down on their left leg, breaking it."
				M << "Your left leg is stricken by the flaming cane and shattered."
				D.broken = 1
	..()

	return

/obj/item/weapon/cane/dropped()
	src.flaming = 0
	src.icon_state = "cane"
	src.s_istate = "cane"
