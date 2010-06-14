/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/ai))
		return 1
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	spawn( 0 )
		if ((A && yes))
			A.Bumped(src)
		return
	..()
	return