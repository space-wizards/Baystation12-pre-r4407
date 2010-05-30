/obj/machinery/firealarm/burn(fi_amount)
	if(src.detecting)
		src.alarm()			// added check of detector status here
		var/area/A = src.loc
		A = A.loc
	//	src.reset = 30.0
	//	for (var/obj/machinery/firealarm/fbi in A)
	//		fbi.reset = 30.0
	return


/obj/machinery/firealarm/receivemessage(message,sender)
	if(..())
		return
	var/command = uppertext(stripnetworkmessage(message))
	var/list/listofcommand = dd_text2list(command," ",null)
	if(listofcommand.len < 2)
		return
	if(checkcommand(listofcommand,1,"ALARM"))
		if(checkcommand(listofcommand,2,"SET"))
			alarm()
		else if(checkcommand(listofcommand,2,"CLEAR"))
			reset()
		src.updateUsrDialog()
	if(checkcommand(listofcommand,1,"LOCK"))
		if(checkcommand(listofcommand,2,"SET"))
			alarm(1)
		else if(checkcommand(listofcommand,2,"CLEAR"))
			reset(1)
		src.updateUsrDialog()
	else if(checkcommand(listofcommand,1,"TIMER") && listofcommand.len >= 2)
		switch (listofcommand[2])
			if ("SET")
				if(listofcommand.len >= 3)
					src.time = text2num(listofcommand[3])
			if ("START")
				src.timing = 1
			if ("STOP")
				src.timing = 0
		src.updateUsrDialog()

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wirecutters))
		src.detecting = !( src.detecting )
		if (src.detecting)
			viewers(user, null) << text("\red [] has reconnected []'s detecting unit!", user, src)
		else
			viewers(user, null) << text("\red [] has disconnected []'s detecting unit!", user, src)
	else
		src.alarm()
	src.add_fingerprint(user)
	return

/obj/machinery/firealarm/process()
	if(stat & (NOPOWER|BROKEN))
		return
//	reset--
	use_power(10, ENVIRON)
//	if (src.reset >= 0) reset()
	if (src.timing)
		if (src.time > 0)
			src.time = round(src.time) - 1
		else
			alarm()
			src.time = 0
			src.timing = 0
		src.updateDialog()
	return

/obj/machinery/firealarm/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "firealarm"
	else
		spawn(rand(0,15))
			stat |= NOPOWER
			icon_state = "firealarm-p"

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	var/area/A = src.loc
	var/d1
	var/d2
	if(user.zombie)
		var/area/B = A.loc
		for(var/mob/C in viewers())
			C.show_message("[user.name] flails at [src]")
		if(prob(10))
			if(B.fire)
				reset()
			else
				alarm()
		return
	if (istype(user, /mob/human) || istype(user, /mob/ai))
		A = A.loc

		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=firealarm")
	else
		A = A.loc
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>[]</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", stars("Fire alarm"), d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=firealarm")
	return

/obj/machinery/firealarm/Topic(href, href_list)
	..()
	if (usr.stat || stat & (BROKEN|NOPOWER))
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["reset"])
			src.reset()
		else
			if (href_list["alarm"])
				src.alarm()
			else
				if (href_list["time"])
					src.timing = text2num(href_list["time"])
				else
					if (href_list["tp"])
						var/tp = text2num(href_list["tp"])
						src.time += tp
						src.time = min(max(round(src.time), 0), 120)
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=firealarm")
		return
	return

/obj/machinery/firealarm/proc/reset(var/lock = 0)
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	if(lock)
		A.lockdownreset()
	else
		A.firereset()
	lockdownbyai = 0
	return

/obj/machinery/firealarm/proc/alarm(var/lock = 0)
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	if(lock)
		A.lockdown()
		lockdownbyai = 1
	else
		A.firealert()
	return

/obj/machinery/partyalarm/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/partyalarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	var/area/A = src.loc
	var/d1
	var/d2
	if (istype(user, /mob/human) || istype(user, /mob/ai))
		A = A.loc

		if (A.party)
			d1 = text("<A href='?src=\ref[];reset=1'>No Party :(</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>PARTY!!!</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>Party Button</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
	else
		A = A.loc
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("No Party :("))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("PARTY!!!"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = src.time % 60
		var/minute = (src.time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>[]</B> []\n<HR>\nTimer System: []<BR>\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT></BODY></HTML>", stars("Party Button"), d1, d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
	return

/obj/machinery/partyalarm/proc/reset()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.partyreset()
	return

/obj/machinery/partyalarm/proc/alarm()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.partyalert()
	return

/obj/machinery/partyalarm/Topic(href, href_list)
	..()
	if (usr.stat || stat & (BROKEN|NOPOWER))
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["reset"])
			src.reset()
		else
			if (href_list["alarm"])
				src.alarm()
			else
				if (href_list["time"])
					src.timing = text2num(href_list["time"])
				else
					if (href_list["tp"])
						var/tp = text2num(href_list["tp"])
						src.time += tp
						src.time = min(max(round(src.time), 0), 120)
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=partyalarm")
		return
	return