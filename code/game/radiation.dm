
var/global/global_radiation = 0

proc/radiate_station()
	spawn
		var/list/tls = new
		for(var/turf/station/H in world)
			tls+=H
		var/turf/station/S = pick(tls)
		while(global_radiation)
			sleep(100)
			S.radiate_turf(S.radiation + 30)


turf/proc/radiate_turf(var/amount)
	src.radiation = amount
	for(var/turf/station/S in oview(src, 1))
		if(S.radiation < src.radiation - 30)
			S.radiate_turf(src.radiation - 30)

/mob/proc/has_air_contact()
	return 0

/mob/monkey/has_air_contact()
	return 1

/mob/human/has_air_contact()
	if(istype(src.wear_suit, /obj/item/weapon/clothing/suit/bio_suit) || istype(src.wear_suit, /obj/item/weapon/clothing/suit/sp_suit))
		if(istype(src.head, /obj/item/weapon/clothing/head/s_helmet) || istype(src.head, /obj/item/weapon/clothing/head/bio_hood))
			return 0
	return 1
