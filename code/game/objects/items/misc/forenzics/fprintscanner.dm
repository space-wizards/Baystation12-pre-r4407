

/obj/item/weapon/f_print_scanner/attackby(obj/item/weapon/f_card/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/f_card))
		if (W.fingerprints)
			return
		if (src.amount == 20)
			return
		if (W.amount + src.amount > 20)
			src.amount = 20
			W.amount = W.amount + src.amount - 20
		else
			src.amount += W.amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	return

/obj/item/weapon/f_print_scanner/attack_self(mob/user as mob)

	src.printing = !( src.printing )
	src.icon_state = text("f_print_scanner[]", src.printing)
	add_fingerprint(user)
	return

/obj/item/weapon/f_print_scanner/attack(mob/human/M as mob, mob/user as mob)

	if ((!( ismob(M) ) || !( istype(M.primary, /obj/dna) ) || !( istype(M, /mob/human) ) || M.gloves))
		user << text("\blue Unable to locate any fingerprints on []!", M)
		return 0
	else
		if ((src.amount < 1 && src.printing))
			user << text("\blue Fingerprints scanned on []. Need more cards to print.", M)
			src.printing = 0
	src.icon_state = text("f_print_scanner[]", src.printing)
	if (src.printing)
		src.amount--
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.fingerprints = md5(M.primary.uni_identity)
		F.icon_state = "f_print_card1"
		F.name = text("FPrintC- '[]'", M.name)
		user << "\blue Done printing."
	user << text("\blue []'s Fingerprints: []", M, md5(M.primary.uni_identity))
	return

/obj/item/weapon/f_print_scanner/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)

	src.add_fingerprint(user)
	if (!( A.fingerprints ))
		user << "\blue Unable to locate any fingerprints!"
		return 0
	else
		if ((src.amount < 1 && src.printing))
			user << "\blue Fingerprints found. Need more cards to print."
			src.printing = 0
	src.icon_state = text("f_print_scanner[]", src.printing)
	if (src.printing)
		src.amount--
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.fingerprints = A.fingerprints
		F.icon_state = "f_print_card1"
		user << "\blue Done printing."
	var/list/L = params2list(A.fingerprints)
	user << text("\blue Isolated [] fingerprints.", L.len)
	for(var/i in L)
		user << text("\blue \t []", i)
		//Foreach goto(186)
	return