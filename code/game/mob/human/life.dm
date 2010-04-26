/mob/human/Life()
	set invisibility = 0
	set background = 1

	var/turf/T = src.loc
	var/oxcheck
	var/plcheck

	src.updatehealth()
	if (src.monkeyizing)
		return

	var/obj/move/shuttlefloor = locate(/obj/move, T)	// fuck obj/move
	if (isturf(T))	//let cryo/sleeper handle adjusting body temp in their respective alter_health procs
		src.bodytemperature = adjustBodyTemp(src.bodytemperature, (shuttlefloor ? shuttlefloor.temp : T.temp), 0.5)

	var/obj/item/weapon/organ/external/Head = src.organs["head"]
	if(src.rname != "Unknown" && src.health < -500 && (Head.get_damage() > Head.max_damage/2) && !src.wear_id)	//this could be done better :effort:
		src.rname = "Unknown"
		src.unlock_medal("Black And Blue", 1, "Get beaten to the point where you are unrecognizable.", "medium")
	if(src.toxloss + src.bruteloss > 50 && prob(10))
		src.loc.add_blood(src,"hit",0)


	if (src.stat != 2)

/////////////////////////////////
		if (src.firemut)
			if (prob(25) && src.toxloss > 5)
				src.toxloss -= 5
			else
				src.toxloss = 0
			var/turf/U
			U = src.loc
			if (istype(U, /turf))
				U.firelevel = U.poison
		if (src.clumsy && prob(1))
			if (!src.lying)
				src << "\red You stumble and hit your head."
				src.paralysis = rand(3,10)
				src.bruteloss += 5
		if (src.clumsy && prob(1) && src.equipped())
			src << "\red You decide that you dont need that thing in your hand."
			src.drop_item()
	//	var/obj/item/weapon/organ/external/RA = src.contents["r_arm"]
	//	var/obj/item/weapon/organ/external/LA = src.contents["l_arm"]
	//	var/obj/item/weapon/organ/external/LH = src.contents["l_hand"]
	//	var/obj/item/weapon/organ/external/RH = src.contents["r_hand"]
	//	if (RA.broken == 1 || RH.broken == 1 && src.equipped())
	//		src << "\red You can't pick up that item as your right arm is broken."
	//		src.drop_item()
	//	if (LA.broken == 1 || LH.broken == 1 && src.equipped())
	//		src << "\red You can't pick up that item as your left arm is broken."
	//		src.drop_item()
		if (src.ishulk)
			if (prob(5) && src.equipped())
				src << "\red Hulk not need baby item!"
				src.drop_item()
		if (src.zombie)
			if (src.equipped())
				src << "\red Hnnngh noooot braiiiiiiiins."
				src.drop_item()
			src.paralysis = 0
			src.stunned = 0
			src.weakened = 0
			src.drowsyness = 0
			if (src.oxyloss > 0) // zombies dont breathe dummy.
				src.oxyloss = 0
			if (prob(10))
				///////////////////////
				if (src.fireloss > 5)
					src.fireloss -= 5
				else
					src.fireloss = 0
				///////////////////////
				if (src.bruteloss > 5)
					src.bruteloss -= 2
				else
					src.bruteloss = 0
				///////////////////////
				if (src.toxloss > 5)
					src.toxloss -= 5
				else
					src.toxloss = 0
				///////////////////////
				src.updatehealth()
/////////////////////////////////
		if (src.fireloss > 50.0 && prob(50))
			src.fireloss -= 5
		else if (src.fireloss > 1.0 && prob(50))
			src.fireloss--
		if (src.radiation < 0)
			src.radiation = 0
		if (src.radiation > 100)
			src.radiation = 100
		if ((prob(1) && (src.radiation >= 75)))
			randmutb(src)
			src << "\red High levels of Radiation cause you to spontaneously mutate."
			domutcheck(src,null)
		if (prob(10) && (src.radiation > 1))
			if (src.radiation >= 10)
				src.radiation -= 10
				src.toxloss += 5
				src.updatehealth()
			else
				src.radiation = 0
		else if(src.radiation > 1)
			src.radiation -= 1
		if(src.radiation > 1)
			if(src.antitoxs > 1)
				src.radiation -= (round(src.antitoxs) *2)
/////////////////////////////////
		if (!src.m_flag)
			src.moved_recently = 0
		src.m_flag = null
		if (src.mach)
			if (src.machine)
				src.mach.icon_state = "mach1"
			else
				src.mach.icon_state = null
		if (src.disabilities & 2)
			if ((prob(1) && src.paralysis < 10 && src.r_epil < 1))
				src << "\red You have a seizure!"
				src.paralysis = max(10, src.paralysis)
		if (src.disabilities & 4)
			if ((prob(5) && src.paralysis <= 1 && src.r_ch_cou < 1))
				spawn( 0 )
					emote("cough")
					sleep(10)
					emote("gasp")
					return
		if (src.disabilities & 8)
			if ((prob(10) && src.paralysis <= 1 && src.r_Tourette < 1))
				spawn( 0 )
					emote("twitch")
					say(pick(loggedsay))
					return
		if (src.disabilities & 16)
			if (prob(10))
				src.stuttering = max(10, src.stuttering)
		if (prob(1) && prob(2))
			spawn(0)
				emote("sneeze")
				return
		for(var/obj/virus/V in viri)
			V.affect(src)
		if ((src.internal && !( src.contents.Find(src.internal) )))
			src.internal = null
		if ((!( src.wear_mask ) || !( src.wear_mask.flags | 8 )))
			src.internal = null
		if (src.losebreath > 0)
			src.losebreath--
			if (prob(7))
				spawn(0)
					emote("gasp")
					return
			oxcheck = 7
			plcheck = 0
		else
			if (isobj(T))
				var/obj/O = T
				T = O.alter_health(src)
			if (isturf(T))
				var/t = 1.4E-4
				if (src.health < -75.0)
					t = 5.0E-5
				else
					if (src.health < -50.0)
						t = 1.0E-4
				var/turf_total = T.per_turf()//T.oxygen + T.poison() + T.sl_gas + T.co2 + T.n2
				var/obj/substance/gas/G = new /obj/substance/gas(  )
				G.maximum = 10000 //* T.tot_gas() / CELLSTANDARD // increase the mass of gas you can breath in with the pressure
				if (src.internal)
					src.internal.process(src, G)
					if (src.internals)
						src.internals.icon_state = "internal1"
					if (( src.wear_mask.flags & 4 && (!( istype(src.head, /obj/item/weapon/clothing/head) ) || !( src.head.flags & 2 ))))
						//G.turf_add(T, G.tot_gas() * 0.5)
						//G.turf_take(T, t / 2 * turf_total - G.tot_gas()*0.5)
						G.turf_take(T, (t/2) * turf_total)
				else
					if (src.internals)
						src.internals.icon_state = "internal0"
					G.turf_take(T, t * turf_total)
				if (G.tot_gas() > 650)
					G.turf_add(T, G.tot_gas() - 650)
				if(locate(/obj/move) in T)
					G.oxygen = 200
					G.n2 = 0
					G.plasma = 0
					G.co2 = 0
					G.sl_gas = 0
				src.aircheck(G)
				if(!src.internal)
					for(var/obj/virus/V in T) V.infect(src)
				//second pass at body temp
				var/thermal_layers = 1.0
				if (((istype(src.head, /obj/item/weapon/clothing/head) && src.head.flags & 4) || (istype(src.wear_mask, /obj/item/weapon/clothing/mask) && (!( src.wear_mask.flags & 4 ) && src.wear_mask.flags & 8))))
					thermal_layers  += 0.15
				if (istype(src.w_uniform, /obj/item/weapon/clothing/under))
					thermal_layers  += 0.5
				if (istype(src.shoes, /obj/item/weapon/clothing/shoes))
					thermal_layers  += 0.15
				if (istype(src.gloves, /obj/item/weapon/clothing/gloves))
					thermal_layers  += 0.1
				if (istype(src.wear_suit, /obj/item/weapon/clothing/suit/labcoat))
					thermal_layers += 0.1
				if (istype(src.wear_suit, /obj/item/weapon/clothing/suit/firesuit) || istype(src.wear_suit, /obj/item/weapon/clothing/suit/black_firesuit))
					thermal_layers  += 1.75
				if (istype(src.wear_suit, /obj/item/weapon/clothing/suit/sp_suit) && istype(src.head, /obj/item/weapon/clothing/head/s_helmet))
					thermal_layers  += 5.0
				else if (istype(src.wear_suit, /obj/item/weapon/clothing/suit/sp_suit))
					thermal_layers  += 2.5
				else if (istype(src.wear_suit, /obj/item/weapon/clothing/suit/santa))
					thermal_layers  += 2.5
				if (src.firemut)
					thermal_layers  += 5.0
				src.bodytemperature = adjustBodyTemp(src.bodytemperature, 310.055, thermal_layers)
				if(src.bodytemperature < 283.222 && prob(2) && (!src.firemut))
					emote("shiver")
				if(src.bodytemperature < 282.591 && (!src.firemut))
					if(src.bodytemperature < 250)
						src.fireloss += 4
						src.updatehealth()
						if(src.paralysis <= 2 && is_living())	src.paralysis += 2
					else if(prob(3) && !src.paralysis && is_living())
						if(src.paralysis <= 5)	src.paralysis += 5
						emote("collapse")
						src << "\red You collapse from the cold!"
				if(src.bodytemperature > 327.444  && (!src.firemut))
					if(src.bodytemperature > 345.444)
						if(!src.eye_blurry)	src << "\red The heat blurs your vision!"
						src.eye_blurry = max(4, src.eye_blurry)
						if(prob(3))	src.fireloss += rand(1,2)
					else if(prob(3) && !src.paralysis && !is_living())
						src.paralysis += 2
						emote("collapse")
						src << "\red You collapse from heat exhaustion!"
				plcheck = src.t_plasma
				oxcheck = src.t_oxygen
				G.turf_add(T, G.tot_gas())
		if ((istype(src.loc, /turf/space) && !( locate(/obj/move, src.loc) )))
			var/layers = 20
			// ******* Check
			if (((istype(src.head, /obj/item/weapon/clothing/head) && src.head.flags & 4) || (istype(src.wear_mask, /obj/item/weapon/clothing/mask) && (!( src.wear_mask.flags & 4 ) && src.wear_mask.flags & 8))))
				layers -= 5
			if (istype(src.w_uniform, /obj/item/weapon/clothing/under))
				layers -= 5
			if ((istype(src.wear_suit, /obj/item/weapon/clothing/suit) && src.wear_suit.flags & 8))
				layers -= 10
			if (layers > oxcheck)
				oxcheck = layers
		if ((plcheck && src.health >= 0))
			src.toxloss += plcheck
			src.updatehealth()
		if ((oxcheck && src.health >= 0))
			src.oxyloss += oxcheck
			src.updatehealth()
		else
			if (src.health >= 0)
				if (src.oxyloss >= 10)
					var/amount = max(0.15, 1)
					src.oxyloss -= amount
				else
					src.oxyloss = 0
				src.updatehealth()
		if (src.health <= -100.0)
			death()
		else
			if ((src.sleeping || src.health < 0))
				if (prob(1))
					if (src.health <= 20)
						spawn( 0 )
							emote("gasp")
							return
					else
						spawn( 0 )
							emote("snore")
							return
				if (src.health < 0)
					if (src.rejuv <= 0)
						src.oxyloss++
				src.updatehealth()
				if(src.stat != 2)	src.stat = 1
				if (src.paralysis < 5)
					src.paralysis = 5
			else
				if (src.resting)
					if (src.weakened < 5)
						src.weakened = 5
				else
					if (src.health < 20)
						if (prob(5))
							if (prob(1))
								if (src.health <= 20)
									spawn( 0 )
										emote("gasp")
										return
							if(src.stat != 2)	src.stat = 1
							if (src.paralysis < 2)
								src.paralysis = 2
		src.updatehealth()
		if (src.rejuv > 0)
			src.rejuv--
		if (src.r_fever > 0)
			src.r_fever--
		if (src.r_epil > 0)
			src.r_epil--
			if (src.antitoxs > 0)
				src.r_epil -= 4
		if (src.r_ch_cou > 0)
			src.r_ch_cou--
			if (src.antitoxs > 0)
				src.r_ch_cou -= 4
		if (src.r_Tourette > 0)
			src.r_Tourette--
			if (src.antitoxs > 0)
				src.r_Tourette -= 4
		if (src.antitoxs > 0)
			src.antitoxs--
			if (src.plasma > 0)
				src.antitoxs -= 4
		if (src.plasma > 0)
			src.plasma--
		if (src.b_mercury > 0)
			src.b_mercury--
			if (src.antitoxs > 0)
				src.b_mercury -= 2
		if (src.b_acid > 0)
			src.b_acid -= 2
		src.blinded = null
		if (src.drowsyness > 0)
			src.drowsyness--
			if (src.paralysis > 1)
				src.drowsyness -= 0.5
			else
				if (src.weakened > 1)
					src.drowsyness -= 0.25
			src.eye_blurry = max(2, src.eye_blurry)
			if (prob(5))
				src.sleeping = 1
				src.paralysis = 5
			if ((src.health > -10.0 && src.drowsyness > 1200))
				if (src.antitoxs < 1)
					src.toxloss += plcheck
					src.updatehealth()
					plcheck = 1
		var/mental_danger = 0
		src.updatehealth()
		if (((src.r_epil > 0 && !( src.disabilities & 2 )) || (src.r_Tourette > 0 && !( src.disabilities & 8 ))))
			src.stuttering = max(2, src.drowsyness)
			mental_danger = 1
			src.drowsyness = max(2, src.drowsyness)
			if (!( src.paralysis ))
				if (prob(5))
					src << "\red You have a seizure!"
					src.paralysis = 10
				else
					if (prob(5))
						spawn( 0 )
							emote("twitch")
							return
						src.stunned = 10
					else
						if (prob(30))
							spawn( 0 )
								emote("drool")
								return
		src.updatehealth()
		if (src.health > -10.0)
			var/threshold = 60
			if (mental_danger)
				threshold = 30
			if (src.r_ch_cou > 3600)
				if (src.antitoxs < 1)
					src.toxloss += 1
					src.updatehealth()
					plcheck = 1
					if (prob(15))
						spawn( 0 )
							emote("twitch")
							src.stunned = 2
							return
			if (src.r_epil > threshold * 60)
				if (src.antitoxs < 1)
					src.toxloss += 1
					src.updatehealth()
					plcheck = 1
					if (prob(15))
						spawn( 0 )
							emote("twitch")
							src.stunned = 2
							return
			if (src.r_Tourette > threshold * 60)
				if (src.antitoxs < 1)
					src.toxloss += 1
					src.updatehealth()
					plcheck = 1
					if (prob(15))
						spawn( 0 )
							emote("twitch")
							src.stunned = 2
							return
			if (src.antitoxs > 7200)
				src.toxloss += 1
				src.updatehealth()
				plcheck = 1
				if (prob(15))
					spawn( 0 )
						emote("drool")
						return
			if (src.druggy > 0)
				if (prob(20))
					spawn( 0 )
						emote("drool")
						return
				if (prob(20))
					step(src, pick(NORTH, SOUTH, EAST, WEST))
				if (src.druggy > 50)
					src.toxloss += 1
					src.updatehealth()
					plcheck = 1
		src.updatehealth()
		if (src.health > -50.0)
			if (src.plasma > 0)
				if (src.antitoxs < 1)
					src.toxloss += 1
					src.updatehealth()
					plcheck = 1
					if (prob(15))
						spawn( 0 )
							emote("moan")
							return
			if (src.b_acid > 0)
				if (src.antitoxs < 1000)
					src.toxloss += 4
					src.updatehealth()
					plcheck = 1
					if (prob(15))
						spawn( 0 )
							emote("moan")
							return
		src.updatehealth()
		if (src.b_mercury > 0)
			if (!( src.paralysis ))
				if ((src.canmove && prob(40) && isturf(src.loc)))
					if(src.stat>1)
						return
					var/alt_name
					if (src.name != src.rname)
						if(src.wear_id && src.wear_id.registered)
							alt_name = " (as [src.wear_id.registered])"
						else
							alt_name = " (as Unknown)"
					step(src, pick(NORTH, SOUTH, EAST, WEST))
					if (prob(15) && !src.zombie)
						for(var/mob/M in hearers(src, null))
							M.show_message(text("<B>[]</B>[]: []", src.rname, alt_name, pick(loggedsay)))
							return
/*		if (src.zombie == 1)
			src.UpdateClothing()
			src.name = "zombie"
			src.rname = "zombie"
			src.canmove = 0
			var/muzzled = istype(src.wear_mask, /obj/item/weapon/clothing/mask/muzzle)
			if (src.toxloss != 0 && src.stat != 2)
				src.toxloss -= 1
			if (src.bruteloss != 0 && src.stat != 2)
				src.bruteloss -= 1
			src.icon += rgb(0,150,0)
			for(var/mob/human/O in oviewers(src, null))
				if (O.key == src.key || O.zombie == 1 || src.lying || src.stat == 1 || src.stunned || src.weakened)
					return
				if (O.client)
					walk_towards(src,O,10)
					spawn(10)
						walk(src,0)
				if (get_dist(src.loc,O.loc) <= 1)
					if (muzzled)
						return
					var/damage = rand(1,10)
					O.show_message("\red The zombie spits acid upon you!")
					src.show_message("You spit upon []",O.rname)

					//var/list/zones = list("diaper", "l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")

					//var/zone = pick(zones)

					//var/obj/item/weapon/organ/external/temp = O.organs["[zone]"]
					//temp.take_damage(damage, 0)
					O.toxloss += damage
					O.updatehealth()
			if (prob(25))
				for(var/mob/M in hearers(src, null))
					M.show_message(text("<B>[]</B>: []", src.rname, pick(zombiesay)))
					return
*/
		src.updatehealth()
		if (src.stat != 2)
			if (src.paralysis + src.stunned + src.weakened > 0)
				if (src.stunned > 0)
					src.stunned--
					src.stat = 0
				if (src.weakened > 0)
					src.weakened--
					src.lying = 1
					src.stat = 0
				if (src.paralysis > 0)
					src.paralysis--
					src.blinded = 1
					src.lying = 1
					src.stat = 1
				src.canmove = 0
				var/h = src.hand
				src.hand = 0
				drop_item()
				src.hand = 1
				drop_item()
				src.hand = h
			else
				src.canmove = 1
				src.lying = 0
				src.stat = 0
	else
		src.lying = 1
		src.blinded = 1
		src.stat = 2
		src.canmove = 0
	if (src.stuttering > 0)
		src.stuttering--
	if (src.eye_blind > 0)
		src.eye_blind--
		src.blinded = 1
	if (src.ear_deaf > 0)
		src.ear_deaf--
	else
		if (src.ear_damage < 25)
			src.ear_damage -= 0.05
			if (istype(src.ears, /obj/item/weapon/clothing/ears/earmuffs))
				src.ear_damage -= 0.15
			src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )
	src.pixel_y = 0
	src.pixel_x = 0
	var/add_weight = 0
	if (istype(src.l_hand, /obj/item/weapon/grab))
		add_weight += 1250000.0
	if (istype(src.r_hand, /obj/item/weapon/grab))
		add_weight += 1250000.0
	if (locate(/obj/item/weapon/grab, src.grabbed_by))
		var/a_grabs = 0
		for(var/obj/item/weapon/grab/G in src.grabbed_by)
			G.process()
			if (G)
				if (G.state > 1)
					a_grabs++
					if ((G.state > 2 && src.loc == G.assailant.loc))
						src.density = 0
						src.lying = 0
						switch(G.assailant.dir)
							if(1.0)
								src.pixel_y = 8
							if(2.0)
								src.pixel_y = -8.0
							if(4.0)
								src.pixel_x = 8
							if(8.0)
								src.pixel_x = -8.0
		src.weight = ((src.grabbed_by.len - a_grabs) / 2 + 1) * 1250000.0 + (a_grabs * 2500000.0)
	else
		if (src.lying)
			src.weight = add_weight + 2500000.0
		else
			src.weight = add_weight + 1250000.0
	if ((src.sdisabilities & 1 || istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)))
		src.blinded = 1
	if ((src.sdisabilities & 4 || istype(src.ears, /obj/item/weapon/clothing/ears/earmuffs)))
		src.ear_deaf = 1
	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)
	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)
	if (src.client)
		src.client.screen -= main_hud1.g_dither
		if (src.stat == 2)
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
			src.see_in_dark = 8
			src.see_invisible = 2
		if (src.stat != 2 && istype(src.wear_mask, /obj/item/weapon/clothing/mask/gasmask))
			src.client.screen += main_hud1.g_dither
		if (src.stat != 2 && istype(src.glasses, /obj/item/weapon/clothing/glasses/meson))
			src.sight |= SEE_TURFS
			src.see_in_dark = 3
			src.see_invisible = 0
		else if (src.stat != 2 && istype(src.glasses, /obj/item/weapon/clothing/glasses/thermal))
			src.sight |= SEE_MOBS
			src.see_in_dark = 4
			src.see_invisible = 2
		else if (src.stat != 2 && src.zombie == 1)
			src.sight |= SEE_MOBS
		else if (src.stat != 2)
			src.sight &= ~SEE_TURFS
			src.sight &= ~SEE_MOBS
			src.sight &= ~SEE_OBJS
			src.see_in_dark = 2
			src.see_invisible = 0
		if (src.xray == 1)
			src.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			src.see_in_dark = 4
			src.see_invisible = 4

		if (src.mach)
			if (src.machine)
				src.mach.icon_state = "mach1"
			else
				src.mach.icon_state = "blank"
		if (src.sleep)
			src.sleep.icon_state = text("sleep[]", src.sleeping)
		if (src.rest)
			src.rest.icon_state = text("rest[]", src.resting)
		if (src.healths)
			if (src.stat < 2)
				if (src.health >= 100)
					src.healths.icon_state = "health0"
				else
					if (src.health >= 75)
						src.healths.icon_state = "health1"
					else
						if (src.health >= 50)
							src.healths.icon_state = "health2"
						else
							if (src.health > 20)
								src.healths.icon_state = "health3"
							else
								src.healths.icon_state = "health4"
			else
				src.healths.icon_state = "health5"
		if (src.pullin)
			if (src.pulling)
				src.pullin.icon_state = "pull1"
			else
				src.pullin.icon_state = "pull0"
		if (src.toxin)
			if (plcheck)
				src.toxin.icon_state = "toxin1"
			else
				src.toxin.icon_state = "toxin0"
		if (src.oxygen)
			if (oxcheck)
				src.oxygen.icon_state = "oxy1"
			else
				src.oxygen.icon_state = "oxy0"
		if (src.bodytemp)	//310.055 optimal body temp
			if(src.bodytemperature >= 345.444)
				src.bodytemp.icon_state = "temp4"
			else if(src.bodytemperature >= 335)
				src.bodytemp.icon_state = "temp3"
			else if(src.bodytemperature >= 327.444)
				src.bodytemp.icon_state = "temp2"
			else if(src.bodytemperature >= 316)
				src.bodytemp.icon_state = "temp1"
			else if(src.bodytemperature >= 300)
				src.bodytemp.icon_state = "temp0"
			else if(src.bodytemperature >= 295)
				src.bodytemp.icon_state = "temp-1"
			else if(src.bodytemperature >= 280)
				src.bodytemp.icon_state = "temp-2"
			else if(src.bodytemperature >= 260)
				src.bodytemp.icon_state = "temp-3"
			else
				src.bodytemp.icon_state = "temp-4"
		src.client.screen -= src.hud_used.blurry
		src.client.screen -= src.hud_used.druggy
		src.client.screen -= src.hud_used.vimpaired
		if ((src.blind && src.stat != 2))
			if (src.blinded)
				src.blind.layer = 51
			else
				src.blind.layer = 0
				if ((src.disabilities & 1 && !( istype(src.glasses, /obj/item/weapon/clothing/glasses/regular)  || !( istype(src.glasses, /obj/item/weapon/clothing/glasses/monocle) ))))
					src.client.screen -= src.hud_used.vimpaired
					src.client.screen += src.hud_used.vimpaired
				else
					src.client.screen -= src.hud_used.vimpaired
				if (src.eye_blurry)
					src.client.screen -= src.hud_used.blurry
					src.client.screen += src.hud_used.blurry
				else
					src.client.screen -= src.hud_used.blurry
				if (src.druggy)
					src.client.screen -= src.hud_used.druggy
					src.client.screen += src.hud_used.druggy
				else
					src.client.screen -= src.hud_used.druggy
		if (src.stat != 2)
			if (src.machine)
				if (!( src.machine.check_eye(src) ))
					src.reset_view(null)
			else
				if(!client.adminobs)
					reset_view(null)
	else if ((src.canmove && prob(10) && isturf(src.loc)))
		if(src.stat>1)
			return
		var/alt_name
		if (src.name != src.rname)
			if(src.wear_id && src.wear_id.registered)
				alt_name = " (as [src.wear_id.registered])"
			else
				alt_name = " (as Unknown)"
		if (!prob(3))
			step(src, pick(NORTH, SOUTH, EAST, WEST))
		else
			for(var/mob/human/H in viewers(world.view, src)) // Remove this if its too laggy
				if (H.client)
					walk_towards(src,H,10)
					spawn(50)
						walk(src,0)
					break
		if (prob(10))
			for(var/mob/M in hearers(src, null))
				M.show_message(text("<B>[]</B>[]: []", src.rname, alt_name, pick(loggedsay)))
	//if (src.primary)
		//src.primary.cleanup()
	if (src.buckled)
		src.lying = (istype(src.buckled, /obj/stool/bed)) ? 1 : 0
		if(src.lying)
			src.drop_item()
		src.density = 1
	else
		src.density = !src.lying

	src.UpdateClothing()
	src.updatehealth()

	if(src.noclip)
		src.density = 0

/mob/var/noclip = 0

/mob/verb/noclip()
	if(src.client.holder)
		src.noclip = !src.noclip
		src << "\blue Noclip [src.noclip?"On":"Off"]"