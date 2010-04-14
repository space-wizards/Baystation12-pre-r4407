/obj/item/weapon/extinguisher/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.waterleft)
	..()
	return

/obj/item/weapon/extinguisher/afterattack(atom/target, mob/user , flag)

	if (src.icon_state == "fire_extinguisher1")
		if (src.waterleft < 1)
			return
		if (world.time < src.last_use + 20)
			return
		src.last_use = world.time
		if (istype(target, /area))
			return
		var/cur_loc = get_turf(user)
		var/tar_loc = (isturf(target) ? target : get_turf(target))


		if (get_dist(tar_loc, cur_loc) > 1)
			var/list/close = list(  )
			var/list/far = list(  )
			for(var/T in oview(2, tar_loc))
				if (get_dist(T, tar_loc) <= 1)
					close += T
				else
					far += T
			close += tar_loc
			var/t = null
			t = 1
			while(t <= 14)
				var/obj/effects/water/W = new /obj/effects/water( cur_loc )
				if (rand(1, 3) != 1)
					walk_towards(W, pick(close), null)
				else
					walk_towards(W, pick(far), null)
				sleep(1)
				t++
			src.waterleft--
			src.last_use = world.time
		else
			if (cur_loc == tar_loc)
				new /obj/effects/water( cur_loc )
				src.waterleft -= 0.25
				src.last_use = 1
			else
				var/list/possible = list(  )
				for(var/T in oview(1, tar_loc))
					possible += T
				possible += tar_loc
				var/t = null
				t = 1
				while(t <= 7)
					var/obj/effects/water/W = new /obj/effects/water( cur_loc )
					walk_towards(W, pick(possible), null)
					sleep(1)
					t++
				src.waterleft -= 0.5
				src.last_use = world.time

					// propulsion
		if(istype(cur_loc, /turf/space))
			user.Move(get_step(user, get_dir(target, user) ))
		//

	else
		return ..()
	return

/obj/item/weapon/extinguisher/attack_self(mob/user as mob)
	if (usr.clumsy && prob(50))
		usr << text("\red You drop the extinguisher on your foot.")
		usr.bruteloss += 5
		usr.drop_item()
		return
	if (src.icon_state == "fire_extinguisher0")
		src.icon_state = "fire_extinguisher1"
		src.desc = "The safety is off."
	else
		src.icon_state = "fire_extinguisher0"
		src.desc = "The safety is on."
	return
