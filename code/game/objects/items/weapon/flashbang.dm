/obj/item/weapon/flashbang/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 100)
			src.det_time = 30
			user.show_message("\blue You set the flashbang for 3 second detonation time.")
			src.desc = "It is set to detonate in 3 seconds."
		else
			src.det_time = 100
			user.show_message("\blue You set the flashbang for 10 second detonation time.")
			src.desc = "It is set to detonate in 10 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/flashbang/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (user.clumsy && prob(50))
			user << "\red Huh? How does this thing work?!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( 5 )
				prime()
				return
		else if (!( src.state ))
			user << "\red You prime the flashbang! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/flashbang/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/flashbang/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/flashbang/proc/prime()
	var/turf/T = get_turf(src)
	T.firelevel = T.poison
	for(var/mob/M in viewers(T, null))
		if(M.zombie) continue
		if (locate(/obj/item/weapon/cloaking_device, M))
			for(var/obj/item/weapon/cloaking_device/S in M)
				S.active = 0
				S.icon_state = "shield0"
		if ((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
			flick("e_flash", M.flash)
			if(!M.ishulk) M.stunned = 10
			if(!M.ishulk) M.weakened = 3
			M << "\red <B>BANG</B>"
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(10, 20)
			else
				if (prob(30))
					M.ear_damage += rand(7, 14)
			if (!( M.paralysis ))
				M.eye_stat += rand(10, 15)
			if (prob(10))
				M.eye_stat += 7
			M.ear_deaf += 30
			if (M == src.loc)
				M.eye_stat += 10
				if (prob(60))
					if (istype(M, /mob/human))
						var/mob/human/H = M
						if (!( istype(H.ears, /obj/item/weapon/clothing/ears/earmuffs) ))
							M.ear_damage += 15
							M.ear_deaf += 60
					else
						M.ear_damage += 15
						M.ear_deaf += 60
		else
			if (get_dist(M, T) <= 5)
				flick("e_flash", M.flash)
				if (!( istype(M, /mob/human) ))
					if(!M.ishulk) M.stunned = 7
					if(!M.ishulk) M.weakened = 2
				else
					var/mob/human/H = M
					M.ear_deaf += 10
					if (prob(20))
						M.ear_damage += 10
					if ((!( istype(H.glasses, /obj/item/weapon/clothing/glasses/sunglasses) ) || M.paralysis))
						if(!M.ishulk) M.stunned = 7
						if(!M.ishulk) M.weakened = 2
					else
						if (!( M.paralysis ))
							M.eye_stat += rand(1, 3)
				M << "\red <B>BANG</B>"
			else
				if (!( istype(M, /mob/human) ))
					flick("flash", M.flash)
				else
					var/mob/human/H = M
					if (!( istype(H.glasses, /obj/item/weapon/clothing/glasses/sunglasses) ))
						flick("flash", M.flash)
				M.eye_stat += rand(1, 2)
				M.ear_deaf += 5
				M << "\red <B>BANG</B>"
		if (M.eye_stat >= 20)
			M << "\red Your eyes start to burn badly!"
			M.disabilities |= 1
			if (prob(M.eye_stat - 20 + 1))
				M << "\red You go blind!"
				M.sdisabilities |= 1
		if (M.ear_damage >= 15)
			M << "\red Your ears start to ring badly!"
			if (prob(M.ear_damage - 10 + 5))
				M << "\red You go deaf!"
				M.sdisabilities |= 4
		else
			if (M.ear_damage >= 5)
				M << "\red Your ears start to ring!"

	for(var/obj/blob/B in view(8,T))
		var/damage = round(30/(get_dist(B,T)+1))
		B.health -= damage
		B.update()
	del(src)
	return

/obj/item/weapon/flashbang/attack_self(mob/user as mob)
	if (!src.state)
		if (user.clumsy)
			user << "\red Huh? How does this thing work?!"
			spawn( 5 )
				prime()
				return
		else
			user << "\red You prime the flashbang! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			add_fingerprint(user)
			spawn( src.det_time )
				prime()
				return
	return