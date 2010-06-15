/obj/machinery/computer/engine/req_access = list(access_eject_engine)

/obj/machinery/computer/engine/New()
	if (!( engine_eject_control ))
		engine_eject_control = new /datum/engine_eject(  )
	..()

	spawn(5)
		for(var/obj/machinery/gas_sensor/G in machines)
			if(G.id == src.id)
				gs = G
				break
	return

/obj/machinery/computer/engine/attackby(var/obj/O, mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/engine/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/engine/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/engine/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if (src.temp)
		dat = "<TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>"
	else
		if (engine_eject_control.status == 0)

			dat = "<B>Engine Gas Monitor</B><HR>"
			if(gs)
				dat += "[gs.sense_string()]"

			else
				dat += "No sensor found."


			dat += "<BR><B>Engine Ejection Module</B><HR>\nStatus: Docked<BR>\n<BR>\nCountdown: [engine_eject_control.timeleft]/60 <A href='?src=\ref[src];reset=1'>\[Reset\]</A><BR>\n<BR>\n<A href='?src=\ref[src];eject=1'>Eject Engine</A><BR>\n<BR>\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"
		else
			if (engine_eject_control.status == 1)
				dat = text("<B>Engine Ejection Module</B><HR>\nStatus: Ejecting<BR>\n<BR>\nCountdown: []/60 \[Reset\]<BR>\n<BR>\n<A href='?src=\ref[];stop=1'>Stop Ejection</A><BR>\n<BR>\n<A href='?src=\ref[];mach_close=computer'>Close</A>", engine_eject_control.timeleft, src, user)
			else
				dat = text("<B>Engine Ejection Module</B><HR>\nStatus: Ejected<BR>\n<BR>\nCountdown: N/60 \[Reset\]<BR>\n<BR>\nEngine Ejected!<BR>\n<BR>\n<A href='?src=\ref[];mach_close=computer'>Close</A>", user)
	user << browse(dat, "window=computer;size=400x500")
	return

/obj/machinery/computer/engine/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)
	src.updateDialog()
	switch(engine_eject_control.status)
		if(-1)
			icon_state = "engine-ejected"
		if(0)
			icon_state = "engine"
		else
			icon_state = "engine-alert"
	return

/obj/machinery/computer/engine/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src

		if (href_list["eject"])
			if (engine_eject_control.status == 0)
				src.temp = "Eject Engine?<BR><BR><B><A href='?src=\ref[src];eject2=1'>\[Swipe ID to initiate eject sequence\]</A></B><BR><A href='?src=\ref[src];temp=1'>Cancel</A>"

		else if (href_list["eject2"])
			var/obj/item/weapon/card/id/I = usr.equipped()
			if (istype(I))
				if(src.check_access(I))
					if (engine_eject_control.status == 0)
						engine_eject_control.ejectstart()
						src.temp = null
				else
					usr << "\red Access Denied."
		else if (href_list["stop"])
			if (engine_eject_control.status > 0)
				src.temp = text("Stop Ejection?<BR><BR><A href='?src=\ref[];stop2=1'>Yes</A><BR><A href='?src=\ref[];temp=1'>No</A>", src, src)

		else if (href_list["stop2"])
			if (engine_eject_control.status > 0)
				engine_eject_control.stopcount()
				src.temp = null

		else if (href_list["reset"])
			if (engine_eject_control.status == 0)
				engine_eject_control.resetcount()

		else if (href_list["temp"])
			src.temp = null

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
