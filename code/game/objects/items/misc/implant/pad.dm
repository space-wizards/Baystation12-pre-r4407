/obj/item/weapon/implantpad/proc/update()

	if (src.case)
		src.icon_state = "implantpad-1"
	else
		src.icon_state = "implantpad-0"
	return

/obj/item/weapon/implantpad/attack_hand(mob/user as mob)

	if ((src.case && (user.l_hand == src || user.r_hand == src)))
		if (user.hand)
			user.l_hand = src.case
		else
			user.r_hand = src.case
		src.case.loc = user
		src.case.layer = 52
		src.case.add_fingerprint(user)
		src.case = null
		user.UpdateClothing()
		src.add_fingerprint(user)
		update()
	else
		if (user.contents.Find(src))
			spawn( 0 )
				src.attack_self(user)
				return
		else
			return ..()
	return

/obj/item/weapon/implantpad/attackby(obj/item/weapon/implantcase/C as obj, mob/user as mob)

	if (istype(C, /obj/item/weapon/implantcase))
		if (!( src.case ))
			user.drop_item()
			C.loc = src
			src.case = C
	else
		return
	src.update()
	return

/obj/item/weapon/implantpad/attack_self(mob/user as mob)

	user.machine = src
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	if (src.case)
		if (src.case.imp)
			if (istype(src.case.imp, /obj/item/weapon/implant/tracking))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				dat += text("<b>Implant Specifications:</b><BR>\n<b>Name:</b> Tracking Beacon<BR>\n<b>Zone:</b> Spinal Column> 2-5 vertebrae<BR>\n<b>Power Source:</b> Nervous System Ion Withdrawl Gradient<BR>\n<b>Life:</b> 10 minutes after death of host<BR>\n<b>Important Notes:</b> None<BR>\n<HR>\n<b>Implant Details:</b> <BR>\n<b>Function:</b> Continuously transmits low power signal on frequency- Useful for tracking.<BR>\nRange: 35-40 meters<BR>\n<b>Special Features:</b><BR>\n<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if\na malfunction occurs thereby securing safety of subject. The implant will melt and\ndisintegrate into bio-safe elements.<BR>\n<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the\ncircuitry. As a result neurotoxins can cause massive damage.<HR>\nImplant Specifics:\nFrequency (144.1-148.9): <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\nID (1-100): <A href='?src=\ref[];id=-10'>-</A><A href='?src=\ref[];id=-1'>-</A> [] <A href='?src=\ref[];id=1'>+</A><A href='?src=\ref[];id=10'>+</A><BR>", src, src, T.freq, src, src, src, src, T.id, src, src)
			else if (istype(src.case.imp, /obj/item/weapon/implant/freedom))
				dat += "<b>Implant Specifications:</b><BR>\n<b>Name:</b> Freedom Beacon<BR>\n<b>Zone:</b> Right Hand> Near wrist<BR>\n<b>Power Source:</b> Lithium Ion Battery<BR>\n<b>Life:</b> optimum 5 uses<BR>\n<b>Important Notes: <font color='red'>Illegal</font></b><BR>\n<HR>\n<b>Implant Details:</b> <BR>\n<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking\nmechanisms<BR>\n<b>Special Features:</b><BR>\n<i>Neuro-Scan</i>- Analyzes certain shadow signals in the Nervous system\n<BR>\n<b>Integrity:</b> The battery is extremely weak and commonly after injection its\nlife can drive down to only 1 use.<HR>\nNo Implant Specifics"
			else if (istype(src.case.imp, /obj/item/weapon/implant/stun))
				dat += "<b>Implant Specifications:</b><BR>\n<b>Name:</b> Stun device<BR>\n<b>Zone:</b> Nervous system> Near spine<BR>\n<b>Power Source:</b> Lithium Ion Battery<BR>\n<b>Life:</b> 1 use<BR>\n<HR>\n<b>Implant Details:</b> <BR>\n<b>Function:</b> \nmechanisms<BR>\n<b>Special Features:</b><BR>\n<i>Neuro-Scan</i>- Analyzes certain shadow signals in the Nervous system\n<BR>\n<b>Integrity:</b> The battery is extremely weak and commonly after injection its\nlife can drive down to only 1 use.<HR>\nNo Implant Specifics"

			else
				dat += "Implant ID not in database"
		else
			dat += "The implant casing is empty."
	else
		dat += "Please insert an implant casing!"
	user << browse(dat, "window=implantpad")
	return

/obj/item/weapon/implantpad/Topic(href, href_list)
	..()
	if (usr.stat)
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["freq"])
			if ((istype(src.case, /obj/item/weapon/implantcase) && istype(src.case.imp, /obj/item/weapon/implant/tracking)))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				T.freq += text2num(href_list["freq"])
				if (round(T.freq * 10, 1) % 2 == 0)
					T.freq += 0.1
				T.freq = min(148.9, T.freq)
				T.freq = max(144.1, T.freq)
		if (href_list["id"])
			if ((istype(src.case, /obj/item/weapon/implantcase) && istype(src.case.imp, /obj/item/weapon/implant/tracking)))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				T.id += text2num(href_list["id"])
				T.id = min(100, T.id)
				T.id = max(1, T.id)
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
				//Foreach goto(290)
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=implantpad")
		return
	return