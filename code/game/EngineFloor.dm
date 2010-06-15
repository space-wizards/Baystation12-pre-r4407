
/turf/station/engine/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/turf/station/engine/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/station/engine/floor/ex_act(severity)
	switch(severity)
		if(1.0)
			var/turf/space/S = src.ReplaceWithSpace()
			S.buildlinks()
			del(src)
			return
		if(2.0)
			if (prob(50))
				var/turf/space/S = src.ReplaceWithSpace()
				S.buildlinks()
				del(src)
				return
		else
	return

/turf/station/engine/floor/blob_act()
	if (prob(15))
		var/turf/space/S = src.ReplaceWithSpace()
		S.buildlinks()
		del(src)
		return
	return

