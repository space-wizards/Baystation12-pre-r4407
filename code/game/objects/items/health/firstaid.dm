/obj/item/weapon/storage/firstaid/fire/New()
	..()
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/healthanalyzer( src )
	var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 15 / C.molarmass
	S.chem.chemicals[text("[]", C.name)] = C
	S.icon_state = "syringe_15"
	return

/obj/item/weapon/storage/firstaid/syringes/New()
	..()
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	new /obj/item/weapon/syringe( src )
	return

/obj/item/weapon/storage/firstaid/regular/New()

	..()
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/brutepack( src )
	new /obj/item/weapon/spraygel( src )
	new /obj/item/weapon/ointment( src )
	new /obj/item/weapon/healthanalyzer( src )
	var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 15 / C.molarmass
	S.chem.chemicals[text("[]", C.name)] = C
	S.icon_state = "syringe_15"
	return

/obj/item/weapon/storage/firstaid/toxin/New()

	..()
	new /obj/item/weapon/pill_canister/antitoxin( src )
	new /obj/item/weapon/pill_canister/antitoxin( src )
	var/t = null
	t = 1
	while(t <= 4)
		var/obj/item/weapon/syringe/S = new /obj/item/weapon/syringe( src )
		var/datum/chemical/pl_coag/C = new /datum/chemical/pl_coag( null )
		C.moles = C.density * 15 / C.molarmass
		S.chem.chemicals[text("[]", C.name)] = C
		S.icon_state = "syringe_15"
		t++
	new /obj/item/weapon/healthanalyzer( src )
	return

/obj/item/weapon/storage/firstaid/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (src.contents.len >= 7)
		return
	if ((W.w_class >= 2 || istype(W, /obj/item/weapon/storage)))
		return
	..()
	return