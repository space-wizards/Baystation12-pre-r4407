/obj/item/weapon/radio/proc/accept_rad(obj/item/weapon/radio/R as obj, message)

	if ((R.freq == src.freq && message))
		return 1
	else
		return null
	return

/obj/item/weapon/radio/proc/r_signal()

	return

/obj/item/weapon/radio/proc/send_crackle()

	if ((src.listening && src.wires & 2))
		return hearers(3, src.loc)
	return

/obj/item/weapon/radio/proc/sendm(msg)
	if(last_transmission && world.time < (last_transmission + TRANSMISSION_DELAY))
		return
	last_transmission = world.time
	if ((src.listening && src.wires & 2))
		return hearers(1, src.loc)
	return

/obj/item/weapon/radio/examine()
	set src in view()

	..()
	if (((get_dist(src, usr) <= 1 || usr.telekinesis == 1) || src.loc == usr))
		if (src.b_stat)
			usr.show_message("\blue The radio can be attached and modified!")
		else
			usr.show_message("\blue The radio can not be modified or attached!")
	return

/obj/item/weapon/radio/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.machine = src
	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.b_stat = !( src.b_stat )
	if (src.b_stat)
		user.show_message("\blue The radio can now be attached and modified!")
	else
		user.show_message("\blue The radio can no longer be modified or attached!")
	for(var/mob/M in viewers(1, src))
		if (M.client)
			src.attack_self(M)
		//Foreach goto(83)
	src.add_fingerprint(user)
	return

/obj/item/weapon/radio/attack_self(mob/user as mob)
	user.machine = src
	var/t1
	if (src.b_stat)
		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = text("<TT>Microphone: []<BR>\nSpeaker: []<BR>\nFrequency: <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\n[]</TT>", (src.broadcasting ? text("<A href='?src=\ref[];talk=0'>Engaged</A>", src) : text("<A href='?src=\ref[];talk=1'>Disengaged</A>", src)), (src.listening ? text("<A href='?src=\ref[];listen=0'>Engaged</A>", src) : text("<A href='?src=\ref[];listen=1'>Disengaged</A>", src)), src, src, src.freq, src, src, t1)
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/radio/Topic(href, href_list)
	//..()
	if (usr.stat)
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf)) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["track"])
			var/mob/target = locate(href_list["track"])
			var/mob/ai/A = locate(href_list["track2"])
			A.switchCameramob(target)
			return
		if (href_list["freq"])
			src.freq += text2num(href_list["freq"])
			if (round(src.freq * 10, 1) % 2 == 0)
				src.freq += 0.1
			src.freq = min(148.9, src.freq)
			src.freq = max(144.1, src.freq)
			if (src.traitorfreq && round(src.freq * 10, 1) == round(src.traitorfreq * 10, 1))
				usr.machine = null
				usr << browse(null, "window=radio")
				// now transform the regular radio, into a (disguised)syndicate uplink!
				var/obj/item/weapon/syndicate_uplink/T = src.traitorradio
				var/obj/item/weapon/radio/R = src
				R.loc = T
				T.loc = usr
				R.layer = 0
				if (usr.client)
					usr.client.screen -= R
				if (usr.r_hand == R)
					usr.u_equip(R)
					usr.r_hand = T
				else
					usr.u_equip(R)
					usr.l_hand = T
				R.loc = T
				T.layer = 52
				T.attack_self(usr)
				return
		else
			if (href_list["talk"])
				src.broadcasting = text2num(href_list["talk"])
			else
				if (href_list["listen"])
					src.listening = text2num(href_list["listen"])
				else
					if (href_list["wires"])
						var/t1 = text2num(href_list["wires"])
						if (!( istype(usr.equipped(), /obj/item/weapon/wirecutters) ))
							return
						if (t1 & 1)
							if (src.wires & 1)
								src.wires &= 65534
							else
								src.wires |= 1
						else
							if (t1 & 2)
								if (src.wires & 2)
									src.wires &= 65533
								else
									src.wires |= 2
							else
								if (t1 & 4)
									if (src.wires & 4)
										src.wires &= 65531
									else
										src.wires |= 4
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				src.updateDialog()
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				src.updateDialog()
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=radio")
		return
	return

obj/item/weapon/radio/talk_into(mob/M as mob, msg)
	if(!global.shortradio)
		for(var/mob/O in viewers(world.view,M))
			O.show_message(text("\icon[] <I>*Static*,*Static*</I>", src), 2)
		return
	if (!( src.wires & 4 ))
		return
	var/list/receive = list(  )
	var/list/crackle = list(  )
	for(var/obj/item/weapon/radio/R in world)
		if (((src.freq == 0 || R.accept_rad(src, msg)) && src.freq != 5))
			for(var/i in R.sendm(msg))
				receive -= i
				receive += i
			for(var/i in R.send_crackle())
				crackle -= i
				crackle += i
	for(var/i in receive)
		crackle -= i
	for(var/mob/O in crackle)
		O.show_message(text("\icon[] <I>Crackle,Crackle</I>", src), 2)
	if (istype(M, /mob/human))
		if (istype(M.wear_mask, /obj/item/weapon/clothing/mask/voicemask))
			name = M.name
		//human
	if (istype(M, /mob/human) && (!M.zombie))
		for(var/mob/O in receive)
			if (istype(O, /mob/human) && (!O.zombie)||(istype(O, /mob/observer)))
				O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, msg), 2)
			else if(istype(O, /mob/ai))
				var/mob/human/H = M
				var/mob/ai/A = O
				if(H.wear_id)
					O.show_message(text("<font color=\"#008000\"><B><a href='byond://?src=\ref[src];track2=\ref[A];track=\ref[]'>[]([])</a>-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", H,H.rname,H.wear_id.assignment, src, src.freq, msg), 2)
				else
					O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", H.rname, src, src.freq, msg), 2)
				//O.show_message(text("<font color=\"#008000\"><B>[]([])-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", H.rname,H.wear_id.assignment, src, src.freq, msg), 2)
			else
				O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, stars(msg)), 2)
		if (src.freq == 5)
			for(var/mob/O in receive)
				if (istype(O, /mob/human) && (!O.zombie))
					O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts (over PA)</B>: <I>[]</I></font>", M.rname, src, src.freq, msg), 2)
				else if(istype(O, /mob/ai))
					var/mob/human/H = M
					var/mob/ai/A = O
					O.show_message(text("<font color=\"#008000\"><B><A href='?[A]=\ref[A];findguy[]'>[]([])</a>-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", H,H.rname,H.wear_id.assignment, src, src.freq, msg), 2)
				else
					O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, stars(msg)), 2)
	//Monkey
	else if (istype(M, /mob/monkey))
		for(var/mob/O in receive)
			if ((istype(O,/mob/monkey)) || (istype(O, /mob/observer)))
				O.show_message(text("<font color=\"#008000\"><B>The monkey-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", src, src.freq, msg), 2)
			else
				O.show_message(text("<font color=\"#008000\"><B>The monkey-\icon[]\[[]\]-broadcasts</B>: chimpering</font>", src, src.freq), 2)
		if (src.freq == 5)
			for(var/mob/O in receive)
				if (istype(O, M))
					O.show_message(text("<font color=\"#008000\"><B>The monkey-\icon[]\[[]\]-broadcasts (over PA)</B>: <I>[]</I></font>", src, src.freq, msg), 2)
				else
					O.show_message(text("<font color=\"#008000\"><B>The monkey-\icon[]\[[]\]-broadcasts (over PA)</B>: chimpering</font>", src, src.freq), 2)
	//zombie
	else if (istype(M, /mob/human) && (M.zombie))
		for(var/mob/O in receive)
			if (istype(O, /mob/human) && (O.zombie)|| istype(O, /mob/observer))
				O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, msg), 2)
			else
				var/zombiespeak1 = "asd"
				zombiespeak1 = pick(zombiesay)
				O.show_message(text("<font color=\"#008000\"><B>The zombie-\icon[]\[[]\]-broadcasts (over PA)</B>:<I>[]<I></font>", src, src.freq, zombiespeak1), 2)
		if (src.freq == 5)
			for(var/mob/O in receive)
				if (istype(O, /mob/human) && (O.zombie) || (istype(O, /mob/observer)))
					O.show_message(text("<font color=\"#008000\"><B>The zombie-\icon[]\[[]\]-broadcasts (over PA)</B>: <I>[]</I></font>", src, src.freq, msg), 2)
				else
					var/zombiespeak1 = "asd"
					zombiespeak1 = pick(zombiesay)
					O.show_message(text("<font color=\"#008000\"><B>The zombie-\icon[]\[[]\]-broadcasts (over PA)</B>:<I>[]<I></font>", src, src.freq, zombiespeak1), 2)
	//AI
	else if (istype(M, /mob/ai))
		for(var/mob/O in receive)
			if (istype(O, /mob/human) && (!O.zombie) || (istype(O, /mob/ai)) ||(istype(O, /mob/observer)))
				O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, msg), 2)
			else
				O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, stars(msg)), 2)
		if (src.freq == 5)
			for(var/mob/O in receive)
				if (istype(O, /mob/human) && (!O.zombie) || (istype(O, /mob/ai)) ||(istype(O, /mob/observer)))
					O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, msg), 2)
				else
					O.show_message(text("<font color=\"#008000\"><B>[]-\icon[]\[[]\]-broadcasts</B>: <I>[]</I></font>", M.rname, src, src.freq, stars(msg)), 2)
	return

/obj/item/weapon/radio/hear_talk(mob/M as mob, msg)
	if (src.broadcasting)
		talk_into(M, msg)
	return