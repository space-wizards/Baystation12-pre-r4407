/obj/machinery/computer/gasmon/New()
	..()
	gs = null
	spawn(5)
		for(var/obj/machinery/gas_sensor/G in machines)
			if(G.id == src.id)
				gs = G
				break
	return

/obj/machinery/computer/gasmon/attackby(var/obj/O, mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/gasmon/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/gasmon/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/gasmon/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat

	dat = "<B>Gas Monitor[tag ? " - " + tag : ""]</B><HR>"

	if(gs != null)
		dat += "[gs.sense_string()]<BR>\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"
	else
		dat += "No sensor found.<BR>\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"

	user << browse(dat, "window=computer;size=400x500")
	return

/obj/machinery/computer/gasmon/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)
	src.updateDialog()
	return

/obj/machinery/computer/gasmon/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return