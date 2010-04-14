/obj/item/weapon/f_card/examine()
	set src in view(2)

	..()
	usr << text("\blue There are [] on the stack!", src.amount)
	usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, display()), text("window=[]", src.name))
	return

/obj/item/weapon/f_card/proc/display()

	if (src.fingerprints)
		var/dat = "<B>Fingerprints on Card</B><HR>"
		var/L = params2list(src.fingerprints)
		for(var/i in L)
			dat += text("[]<BR>", i)
			//Foreach goto(41)
		return dat
	else
		return "<B>There are no fingerprints on this card.</B>"
	return

/obj/item/weapon/f_card/attack_hand(mob/user as mob)

	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 52
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/weapon/f_card/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/f_card))
		if ((src.fingerprints || W.fingerprints))
			return
		if (src.amount == 10)
			return
		if (W:amount + src.amount > 10)
			src.amount = 10
			W:amount = W:amount + src.amount - 10
		else
			src.amount += W:amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	else
		if (istype(W, /obj/item/weapon/pen))
			var/t = input(user, "Card Label:", text("[]", src.name), null)  as text
			if (user.equipped() != W)
				return
			if ((get_dist(src, usr) > 1 && src.loc != user))
				return
			t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
			if (t)
				src.name = text("FPrintC- '[]'", t)
			else
				src.name = "Finger Print Card"
			W.add_fingerprint(user)
			src.add_fingerprint(user)
	return

/obj/item/weapon/f_card/add_fingerprint()

	..()
	if (!istype(usr, /mob/ai))
		if (src.fingerprints)
			if (src.amount > 1)
				var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( (ismob(src.loc) ? src.loc.loc : src.loc) )
				F.amount = --src.amount
				src.amount = 1
			src.icon_state = "f_print_card1"
	return