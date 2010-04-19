
obj/computercable/New()
	..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)

/obj/computercable/hide(var/i)

	invisibility = i ? 101 : 0
	updateicon()


/obj/computercable/proc/updateicon()
	if(invisibility)
		icon_state = "[d1]-[d2][cabletype]-f"
	else
		icon_state = "[d1]-[d2][cabletype]"