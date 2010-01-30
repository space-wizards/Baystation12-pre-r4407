/obj/item/weapon/organ/external/chest/New() // I guess this should be here since after all it is human-related rite?
	spawn (1)
		var/obj/item/weapon/organ/internal/heart/heart = new /obj/item/weapon/organ/internal/heart( src )
		heart.owner = src
		var/obj/item/weapon/organ/internal/lungs/lungs = new /obj/item/weapon/organ/internal/lungs( src )
		lungs.owner = src
		var/obj/item/weapon/organ/internal/intestines/intestines = new /obj/item/weapon/organ/internal/intestines( src )
		intestines.owner = src
		var/obj/item/weapon/organ/internal/liver/liver = new /obj/item/weapon/organ/internal/liver( src )
		liver.owner = src
		var/obj/item/weapon/organ/internal/stomach/stomach = new /obj/item/weapon/organ/internal/stomach( src )
		stomach.owner = src

		src.organs["heart"] = heart
		src.organs["lungs"] = lungs
		src.organs["intestines"] = intestines
		src.organs["liver"] = liver
		src.organs["stomach"] = stomach
/obj/item/weapon/organ/external/head/New()
	spawn (1)
		var/obj/item/weapon/organ/internal/brain/brain = new /obj/item/weapon/organ/internal/brain( src )
		brain.owner = src
		src.organs["brain"] = brain

//obj/item/weapon/organ/internal/proc/take_damage(chem,brute,burn)
//	return

/mob/proc/damage_organ(organ,resistance)
	if (!istype(src,/mob/human)
		return
	var/obj/item/weapon/organ/external/current = (src.organs["chest"]).organs[organ]
//	var/obj/item/weapon/organ/internal/voltage = current.organs[organ]
//	if (prob(25))
//		resistance = (resistance/2) // damaging organs is kinda hard
	voltage.health -= resistance
/*
/obj/item/weapon/organ/internal/New()
	src.process()

/obj/item/weapon/organ/internal/liver/process()
	var/O = src.owner
	var/Q = O.owner
	if (src.owner.stat == 2)
		return
	if (src.health < 75)
		if (prob(25))
			src.owner:toxloss += 2
			src.owner:updatehealth()
	spawn(50)
		src.process()
*/