/turf/space/New()
 ..()
 sd_SetLuminosity(1)

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/weapon/tile/T as obj, mob/user as mob)
	if (istype(T, /obj/item/weapon/tile))
		T.build(src)
		T.amount--
		T.add_fingerprint(user)
		if (T.amount < 1)
			user.u_equip(T)
			del(T)
			return
	return

/turf/space/updatecell()
	oxygen = 0
	poison = 0
	co2 = 0
	sl_gas = 0
	n2 = 0
	temp = 2.7
	return

/turf/space/conduction()
	return

// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc || istype(null, /obj/beam)))
		return

	if (!(A.last_move))
		return

	if (locate(/obj/move, src))
		return 1

	if ((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1)))
		var/mob/M = A

		if ((!( M.handcuffed) && M.canmove))
			var/prob_slip = 5

			if (locate(/obj/grille, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 2
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 1

				if (!( M.r_hand ))
					prob_slip -= 2
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 1
			else if (locate(/obj/move/wall, oview(1, M)) || locate(/turf/station, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 1
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 0.5

				if (!( M.r_hand ))
					prob_slip -= 1
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 0.5
			prob_slip = round(prob_slip)
			if (prob_slip < 5) //next to something, but they might slip off
				if (prob(prob_slip))
					M << "\blue <B>You slipped!</B>"
					M.inertia_dir = M.last_move
					step(M, M.inertia_dir)
					return
				else
					M.inertia_dir = 0 //no inertia
			else //not by a wall or anything, they just keep going
				spawn(5)
					if ((A && !( A.anchored ) && A.loc == src))
						if(M.inertia_dir) //they keep moving the same direction
							step(M, M.inertia_dir)
						else
							M.inertia_dir = M.last_move
							step(M, M.inertia_dir)
		else //can't move, they just keep going (COPY PASTED CODE WOO)
			spawn(5)
				if ((A && !( A.anchored ) && A.loc == src))
					if(M.inertia_dir) //they keep moving the same direction
						step(M, M.inertia_dir)
					else
						M.inertia_dir = M.last_move
						step(M, M.inertia_dir)
	if(ticker && ticker.mode.name == "nuclear emergency")
		return
	if (src.x <= 2)
		if(prob(50))
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 3
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
		else
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 4
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (A.x >= (world.maxx - 1))
		if(prob(50))
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 3
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
		else
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 4
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 2)
		if(prob(50))
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 3
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
		else
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 4
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (A.y >= (world.maxy - 1))
		if(prob(50))
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 3
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
		else
			if(istype(A, /obj/meteor))
				del(A)
				return
			A.z = 4
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
