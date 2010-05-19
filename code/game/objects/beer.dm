/obj/item/weapon/drink/beer/attack(mob/M as mob, mob/user as mob)

	if (user.a_intent == "hurt")
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\red <B>You go to rub your eyes with your hand, forgetting you are holding a broken beer bottle!</b>"
			else
				user << "\red <B>You jab [M] in the face with your broken beer bottle!</b>"
				M << "\red <B>[user] gouges your face with their broken beer bottle!</b>"
			M.stunned += rand(0,2)
			M.bruteloss += 5
			M.eye_blurry += rand(0,10)
			M.updatehealth()

		else // Bottle is not broken, intent is hurt
			if (M == user)
				user << "\red <B>You let out a ferocious yell and smash the beer bottle into your own face!</b>"
			else
				user << "\red <B>You smash the beer bottle over [M]s head!</b>"
				M << "\red <B>[user] smashes a beer bottle over your head!</b>"
			M.bruteloss += 2
			M.stunned += rand(0,2)
			if (prob(40))
				if (user != M)
					user << "\red <B>The bottle shatters!</b>"
				M << "\red <B>The bottle shatters!</b>"
				M.eye_blurry += rand(0,(10-src.amount)) // blur the eyes according to how much beer was left in there
				src.amount = 0
				src.icon_state = "broken_beer"
				M.stunned += rand(0,2)

				M.bruteloss += 2
				M.updatehealth()

	else // Intent = not hurt
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\blue <B>You brandish the jagged remains of the beer bottle in your hand with a devilish flourish!"
			else
				user << "\blue <B>You lovingly caress [M]'s cheek with the broken beer bottle, being careful not to accidentally cut them with the sharp edges.</b>"
				M << "\blue <B>[user] is the sweetest, caressing your cheek with their broken beer bottle, ever so tender... ever so gentle.</b>"

		else // Bottle is not broken, intent is NOT hurt
			if (src.amount <= 0)
				if (M == user)
					user << "\blue <B>You sadly frown as you are only able to shake a single drop of beer from the bottle. :(</b>"
				else
					user << "\blue <B>You try to give [M] some beer, but the bottle is empty :(</b>"
					M << "\blue <B>[user] tried to give you some beer, but sadly the bottle was empty :(</b>"
			else
				if ((user != M && istype(M, /mob/human)))
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] is forcing [] to take a gulp of []", user, M, src), 1)
					var/obj/equip_e/human/O = new /obj/equip_e/human(  )
					O.source = user
					O.target = M
					O.item = src
					O.s_loc = user.loc
					O.t_loc = M.loc
					O.place = "drink"
					M.requests += O
					spawn( 0 )
						O.process()
						return
				else
					src.add_fingerprint(user)
					ingest(M)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				return

/*			else
				src.amount--
				if (M == user)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				else
					user << "\blue <B>You helpfully force a gulp of beer down [M]s throat!</b>"
					M << "\blue <B>[user] helpfully forces a gulp of beer down your throat!</b>"
				M.stunned += rand(0,2)
				M.weakened += rand(0,3)
				M.eye_blurry += rand(0,2)
				if ((prob(20) && M.drowsyness < 30))
					M.drowsyness += 5
					M.drowsyness = min(M.drowsyness, 10)*/

	if (src.icon_state == "broken_beer")
		if (prob(20))
			user << "\blue <B>Sadly, the broken beer bottle disintegrates in your hand, giving you some minor lacerations. A single tear drops from the corner of your eye.</b>"
			user.bruteloss += 4
			user.updatehealth()
			del(src)
	else
		if (prob(5))
			user << "\blue <B>Woops! You dropped your bottle of beer and it shatters to a million pieces.</b>"
			del(src)

/obj/item/weapon/drink/sleepbeer/attack(mob/M as mob, mob/user as mob)

	if (user.a_intent == "hurt")
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\red <B>You go to rub your eyes with your hand, forgetting you are holding a broken beer bottle!</b>"
			else
				user << "\red <B>You jab [M] in the face with your broken beer bottle!</b>"
				M << "\red <B>[user] gouges your face with their broken beer bottle!</b>"
			M.stunned += rand(0,2)
			M.bruteloss += 5
			M.eye_blurry += rand(0,10)
			M.updatehealth()

		else // Bottle is not broken, intent is hurt
			if (M == user)
				user << "\red <B>You let out a ferocious yell and smash the beer bottle into your own face!</b>"
			else
				user << "\red <B>You smash the beer bottle over [M]s head!</b>"
				M << "\red <B>[user] smashes a beer bottle over your head!</b>"
			M.bruteloss += 2
			M.stunned += rand(0,2)
			if (prob(40))
				if (user != M)
					user << "\red <B>The bottle shatters!</b>"
				M << "\red <B>The bottle shatters!</b>"
				M.eye_blurry += rand(0,(10-src.amount)) // blur the eyes according to how much beer was left in there
				src.amount = 0
				src.icon_state = "broken_beer"
				M.stunned += rand(0,2)

				M.bruteloss += 2
				M.updatehealth()

	else // Intent = not hurt
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\blue <B>You brandish the jagged remains of the beer bottle in your hand with a devilish flourish!"
			else
				user << "\blue <B>You lovingly caress [M]'s cheek with the broken beer bottle, being careful not to accidentally cut them with the sharp edges.</b>"
				M << "\blue <B>[user] is the sweetest, caressing your cheek with their broken beer bottle, ever so tender... ever so gentle.</b>"

		else // Bottle is not broken, intent is NOT hurt
			if (src.amount <= 0)
				if (M == user)
					user << "\blue <B>You sadly frown as you are only able to shake a single drop of beer from the bottle. :(</b>"
				else
					user << "\blue <B>You try to give [M] some beer, but the bottle is empty :(</b>"
					M << "\blue <B>[user] tried to give you some beer, but sadly the bottle was empty :(</b>"
			else
				if ((user != M && istype(M, /mob/human)))
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] is forcing [] to take a gulp of []", user, M, src), 1)
					var/obj/equip_e/human/O = new /obj/equip_e/human(  )
					O.source = user
					O.target = M
					O.item = src
					O.s_loc = user.loc
					O.t_loc = M.loc
					O.place = "drink"
					M.requests += O
					spawn( 0 )
						O.process()
						add_food(M,0,10)
						return
				else
					src.add_fingerprint(user)
					ingest(M)
					add_food(M,0,10)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				return
/*			else
				src.amount--
				if (M == user)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				else
					user << "\blue <B>You helpfully force a gulp of beer down [M]s throat!</b>"
					M << "\blue <B>[user] helpfully forces a gulp of beer down your throat!</b>"
				if (M.drowsyness < 600)
					M.drowsyness += 600
					M.drowsyness = min(M.drowsyness, 1800) //puts peeps to sleeps
				if (prob(25))
					M.paralysis += 60
				else if (prob(50))
					M.paralysis += 30*/


	if (src.icon_state == "broken_beer")
		if (prob(20))
			user << "\blue <B>Sadly, the broken beer bottle disintegrates in your hand, giving you some minor lacerations. A single tear drops from the corner of your eye.</b>"
			user.bruteloss += 4
			user.updatehealth()
			del(src)
	else
		if (prob(5))
			user << "\blue <B>Woops! You dropped your bottle of beer and it shatters to a million pieces.</b>"
			del(src)

/obj/item/weapon/drink/killbeer/attack(mob/M as mob, mob/user as mob)

	if (user.a_intent == "hurt")
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\red <B>You go to rub your eyes with your hand, forgetting you are holding a broken beer bottle!</b>"
			else
				user << "\red <B>You jab [M] in the face with your broken beer bottle!</b>"
				M << "\red <B>[user] gouges your face with their broken beer bottle!</b>"
			M.stunned += rand(0,2)
			M.bruteloss += 5
			M.eye_blurry += rand(0,10)
			M.updatehealth()

		else // Bottle is not broken, intent is hurt
			if (M == user)
				user << "\red <B>You let out a ferocious yell and smash the beer bottle into your own face!</b>"
			else
				user << "\red <B>You smash the beer bottle over [M]s head!</b>"
				M << "\red <B>[user] smashes a beer bottle over your head!</b>"
			M.bruteloss += 2
			M.stunned += rand(0,2)
			if (prob(40))
				if (user != M)
					user << "\red <B>The bottle shatters!</b>"
				M << "\red <B>The bottle shatters!</b>"
				M.eye_blurry += rand(0,(10-src.amount)) // blur the eyes according to how much beer was left in there
				src.amount = 0
				src.icon_state = "broken_beer"
				M.stunned += rand(0,2)

				M.bruteloss += 2
				M.updatehealth()

	else // Intent = not hurt
		if (src.icon_state == "broken_beer")
			if (M == user)
				user << "\blue <B>You brandish the jagged remains of the beer bottle in your hand with a devilish flourish!"
			else
				user << "\blue <B>You lovingly caress [M]'s cheek with the broken beer bottle, being careful not to accidentally cut them with the sharp edges.</b>"
				M << "\blue <B>[user] is the sweetest, caressing your cheek with their broken beer bottle, ever so tender... ever so gentle.</b>"

		else // Bottle is not broken, intent is NOT hurt
			if (src.amount <= 0)
				if (M == user)
					user << "\blue <B>You sadly frown as you are only able to shake a single drop of beer from the bottle. :(</b>"
				else
					user << "\blue <B>You try to give [M] some beer, but the bottle is empty :(</b>"
					M << "\blue <B>[user] tried to give you some beer, but sadly the bottle was empty :(</b>"
			else
				if ((user != M && istype(M, /mob/human)))
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] is forcing [] to take a gulp of []", user, M, src), 1)
					var/obj/equip_e/human/O = new /obj/equip_e/human(  )
					O.source = user
					O.target = M
					O.item = src
					O.s_loc = user.loc
					O.t_loc = M.loc
					O.place = "drink"
					M.requests += O
					spawn( 0 )
						O.process()
						return
				else
					src.add_fingerprint(user)
					ingest(M)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				return
/*			else
				src.amount--
				if (M == user)
					user <<"\blue <B>You take a swig of SPACE BEER!</b>"
				else
					user << "\blue <B>You try and force a gulp of beer down [M]s throat!</b>"
					M << "\blue <B>[user] is trying to force a gulp of beer down your throat!</b>"

				if (M.health > -50.0)
					M.toxloss += M.health + 50  //you don't want to drink this shiit
					M.updatehealth()*/

	if (src.icon_state == "broken_beer")
		if (prob(20))
			user << "\blue <B>Sadly, the broken beer bottle disintegrates in your hand, giving you some minor lacerations. A single tear drops from the corner of your eye.</b>"
			user.bruteloss += 4
			user.updatehealth()
			del(src)
	else
		if (prob(5))
			user << "\blue <B>Woops! You dropped your bottle of beer and it shatters to a million pieces.</b>"
			del(src)


/obj/item/weapon/drink/beer/attackby(obj/item/weapon/m_pill/S as obj, mob/user as mob)
	..()
	if(istype(S, /obj/item/weapon/m_pill/sleep))
		var/obj/item/weapon/drink/sleepbeer/R = new /obj/item/weapon/drink/sleepbeer( user )
		S.loc = R
//		R.part1 = S
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
//		R.part2 = src
		R.layer = 52
		R.loc = user
		R.dir = src.dir
		src.add_fingerprint(user)
		return
	if(istype(S, /obj/item/weapon/m_pill/cyanide))
		var/obj/item/weapon/drink/killbeer/R = new /obj/item/weapon/drink/killbeer( user )
		S.loc = R
//		R.part1 = S
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
//		R.part2 = src
		R.layer = 52
		R.loc = user
		R.dir = src.dir
		src.add_fingerprint(user)
		return

/obj/item/weapon/drink/proc/ingest(mob/M as mob)
	src.amount--
	if (src.amount <= 0)
		del(src)
		return
	return
/obj/item/weapon/drink/beer/ingest(mob/M as mob)
	M.stunned += rand(0,2)
	M.weakened += rand(0,3)
	M.eye_blurry += rand(0,2)
//	M.damage_organ("liver",2)
	if (M.radiation > 1)
		M.radiation -= rand(2,5)
	if ((prob(20) && M.drowsyness < 30))
		M.drowsyness += 5
		M.drowsyness = min(M.drowsyness, 10)
/obj/item/weapon/drink/killbeer/ingest(mob/M as mob)
	if (M.radiation > 1)
		M.radiation -= rand(2,5)
	if (M.health > -50.0)
		M.toxloss += M.health + 50  //you don't want to drink this shiit
		M.updatehealth()

/obj/item/weapon/drink/sleepbeer/ingest(mob/M as mob)
	if (M.radiation > 1)
		M.radiation -= rand(2,5)
	if (M.drowsyness < 600)
		M.drowsyness += 600
		M.drowsyness = min(M.drowsyness, 1800) //puts peeps to sleeps
	if (prob(25))
		M.paralysis += 60
	else if (prob(50))
		M.paralysis += 30