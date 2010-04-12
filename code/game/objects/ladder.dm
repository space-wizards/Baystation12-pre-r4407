obj/ladder
		icon = 'ladder.dmi'
		icon_state = "down"
		density = 0
		opacity = 0
		anchored = 1
		var/istop = 1

/obj/ladder/New()
	..()
	if (!istop)
		icon_state = "up"

/obj/ladder/attack_ai(var/mob/A)
	A << "You can't use ladders!"

/obj/ladder/attack_paw(var/mob/M)
	return attack_hand(M)

/obj/ladder/attackby(var/W, var/mob/M)
	return attack_hand(M)

/obj/ladder/attack_hand(var/mob/M)
	var/whatx = src.x
	var/whaty = src.y
	var/whatz = (istop ? src.z + 1 : src.z - 1) //Byond Z-levels are inverted (lower is higher)
	var/turf/targ = locate(whatx, whaty, whatz)
	M.loc = targ