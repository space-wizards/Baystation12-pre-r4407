

/obj/machinery/conveyor_control/New()
	..()
	spawn(2)
		state = getstate()
		updateicon()

/obj/machinery/conveyor_control/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/conveyor_control/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/conveyor_control/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/f_print_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/conveyor_control/process()
	if (stat & (NOPOWER|BROKEN))
		return
	use_power(state ? 5 : 10)

/obj/machinery/conveyor_control/proc/getstate()
	for(var/obj/machinery/conveyor/M in machines)
		if (M.id == src.id)
			return M.on

/obj/machinery/conveyor_control/proc/toggle_power()
	use_power(15)
	hear_sound(sound('sound/machinery/conveyor_control/use.wav', 0, 0, 2, 50), 4)
	state = !getstate()
	src.updateicon()
	spawn(15)
		for(var/obj/machinery/conveyor/M in machines)
			if (M.id == src.id)
				transmitmessage(createmessagetomachine("TOGGLE", M))

/obj/machinery/conveyor_control/attack_hand(mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "<head><title>[name]</title></head><body>"
	if (state)
		dat += "Conveyor Belts are ON (<A HREF='?src=\ref[src];power=1'>Turn Off</a>)<br>"
	else
		dat += "Conveyor Belts are OFF (<A HREF='?src=\ref[src];power=1'>Turn On</a>)<br>"
	dat += "<A HREF='?src=\ref[src];horn=1'>Sound Horn</a>"

	dat += "</body></html>"
	user << browse(dat, "window=controlbox;size=300x75")

/obj/machinery/conveyor_control/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	if (href_list["power"])
		toggle_power()
	else if (href_list["horn"])
		for (var/obj/machinery/conveyor_klaxon/A in machines)
			if (A.id == src.id)
				transmitmessage(createmessagetomachine("SOUND", A))
	src.updateUsrDialog()

/obj/machinery/conveyor_control/updateicon()
	overlays = null
	overlays += image('conveyor.dmi', "cb-s[state]")

	if (stat & (NOPOWER|BROKEN))
		overlays += image('conveyor.dmi', "cb-p")

/obj/machinery/conveyor_control/power_change()
	..()
	updateicon()