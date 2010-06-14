/atom/verb/point()
	set src in oview()

	if ((!( usr ) || !( isturf(usr.loc) )) || isarea(src))		// can't point to areas anymore
		return
	if (usr.stat == 0 && !usr.restrained())
		var/P = new /obj/point( (isturf(src) ? src : src.loc) )
		spawn(20)
			del(P)
			return
		for(var/mob/M in viewers(usr, null))
			M.show_message(text("<B>[]</B> points to []", usr, src), 1)
	return