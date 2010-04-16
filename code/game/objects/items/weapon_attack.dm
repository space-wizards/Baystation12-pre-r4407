/obj/item/weapon/proc/attack(mob/M as mob, mob/user as mob, def_zone)
	var/QQ = rand(1,3)
	if (!src.custom_sound)
		if (src.material == 1)
			user.hear_sound("sound/weapon/generic/hit[QQ].wav",6)
	for(var/mob/O in viewers(M, null))
		O.show_message(text("\red <B>[] has been attacked with [][] </B>", M, src, (user ? text(" by [].", user) : ".")), 1)
	world.log_Mattack(text("[usr.rname] ([usr.key]) attacked [M.rname]([M.key]) with [src]"))
	var/power = src.force
//	if (M.health >= -60.0)
	if (istype(M, /mob/human))
		var/mob/human/H = M
		var/obj/item/weapon/organ/external/affecting = H.organs["chest"]
		if (istype(user, /mob/human))
			if (!( def_zone ))
				var/mob/user2 = user
				var/t = user2.zone_sel.selecting
				if ((t in list( "hair", "eyes", "mouth", "neck" )))
					t = "head"
				def_zone = ran_zone(t)
			if (H.organs[text("[]", def_zone)])
				affecting = H.organs[text("[]", def_zone)]
		if (istype(affecting, /obj/item/weapon/organ/external))
			var/b_dam = (src.damtype == "brute" ? src.force : 0)
			var/f_dam = (src.damtype == "fire" ? src.force : 0)
			if (def_zone == "head")
				if ((b_dam && (((H.head && H.head.brute_protect & 1) || (H.wear_mask && H.wear_mask.brute_protect & 1)) && prob(75))))
					if (prob(20))
						affecting.take_damage(power, 0)
					else
						H.show_message("\red You have been protected from a hit to the head.")
					return
				if ((b_dam && prob(src.force + affecting.brute_dam + affecting.burn_dam)))
					var/time = rand(10, 120)
					if (prob(90))
						if (H.paralysis < time)
							H.paralysis = time
					else
						if (H.weakened < time)
							H.weakened = time
					if(H.stat != 2)	H.stat = 1
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red <B>[] has been knocked unconscious!</B>", H), 1, "\red You hear someone fall.", 2)
					H.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
					if (prob(50))
						if (H.is_rev == 1)
							H.is_rev = 0
							H << "\red <B>You have been brainwashed! You are no longer a revolutionary!</B>"
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/station))
							location.add_blood(H)
					if (H.wear_mask)
						H.wear_mask.add_blood(H)
					if (H.head)
						H.head.add_blood(H)
					if (H.glasses && prob(33))
						H.glasses.add_blood(H)
					if (istype(user, /mob/human))
						var/mob/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
			else if (def_zone == "chest")
				if ((b_dam && (((H.wear_suit && H.wear_suit.brute_protect & 2) || (H.w_uniform && H.w_uniform.brute_protect & 2)) && prob(90 - src.force))))
					H.show_message("\red You have been protected from a hit to the chest.")
					return
				if ((b_dam && prob(src.force + affecting.brute_dam + affecting.burn_dam)))
					if (prob(50))
						if (H.weakened < 5)
							H.weakened = 5
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been knocked down!</B>", H), 1, "\red You hear someone fall.", 2)
					else
						if (H.stunned < 2)
							H.stunned = 2
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been stunned!</B>", H), 1)
					if(H.stat != 2)	H.stat = 1
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/station))
							location.add_blood(H)
					if (H.wear_suit)
						H.wear_suit.add_blood(H)
					if (H.w_uniform)
						H.w_uniform.add_blood(H)
					if (istype(user, /mob/human))
						var/mob/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
			else if (def_zone == "diaper")
				if ((b_dam && (((H.wear_suit && H.wear_suit.brute_protect & 4) || (H.w_uniform && H.w_uniform.brute_protect & 4)) && prob(90 - src.force))))
					H.show_message("\red You have been protected from a hit to the lower chest/diaper.")
					return
				if ((b_dam && prob(src.force + affecting.brute_dam + affecting.burn_dam)))
					if (prob(50))
						if (H.weakened < 5)
							H.weakened = 5
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been knocked down!</B>", H), 1, "\red You hear someone fall.", 2)
					else
						if (H.stunned < 2)
							H.stunned = 2
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been stunned!</B>", H), 1)
					if(H.stat != 2)	H.stat = 1
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/station))
							location.add_blood(H)
					if (H.wear_suit)
						H.wear_suit.add_blood(H)
					if (H.w_uniform)
						H.w_uniform.add_blood(H)
					if (istype(user, /mob/human))
						var/mob/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
			else if (b_dam && prob(25 + (b_dam * 2)))
				src.add_blood(H)
				if (prob(33))
					var/turf/location = H.loc
					if (istype(location, /turf/station))
						location.add_blood(H)
				if (H.wear_suit)
					H.wear_suit.add_blood(H)
				if (H.w_uniform)
					H.w_uniform.add_blood(H)
				if (istype(user, /mob/human))
					var/mob/human/user2 = user
					if (user2.gloves)
						user2.gloves.add_blood(H)
					else
						user2.add_blood(H)
					if (prob(15))
						if (user2.wear_suit)
							user2.wear_suit.add_blood(H)
						else if (user2.w_uniform)
							user2.w_uniform.add_blood(H)
			affecting.take_damage(b_dam, f_dam)
			H.UpdateDamageIcon()
	else
		switch(src.damtype)
			if("brute")
				M.bruteloss += power
			if("fire")
				if (!M.firemut)
					M.fireloss += power
		M.updatehealth()
	src.add_fingerprint(user)
	return
