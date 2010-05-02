/obj/machinery/conveyor/New()
	..()
	updateicon()

/obj/machinery/conveyor/process()
	if (stat & (NOPOWER|BROKEN) || !on)
		return

	use_power(125)

	var/turf/dest = get_step(src.loc, dir)
	var/M = 1

	for (var/atom/A in dest)
		if (A.density)
			M = 0
			break

	if (M)
		for (var/atom/movable/A as mob|obj in src.loc)
			if (!A.anchored)
				spawn(1)
					step(A, dir)

	return

/obj/machinery/conveyor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.drop_item()
	if(W && W.loc)
		W.loc = src.loc
	return

/obj/machinery/conveyor/power_change()
	..()
	updateicon()

/obj/machinery/conveyor/proc/toggle()
	on = !on
	if (on)
		view(4,src) << sound('sound/machinery/conveyor/start.wav', 0, 0, 2, 50)
	else
		view(4,src) << sound('sound/machinery/conveyor/stop.wav', 0, 0, 2, 50)
	spawn(1)
		updateicon()

/obj/machinery/conveyor/updateicon()
	src.icon_state = text("[]", on && !(stat & (NOPOWER|BROKEN)))

/obj/machinery/conveyor/receivemessage(var/message, var/obj/machinery/srcmachine)
	if (..())
		return 1

	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)

	switch (commands[1])
		if ("ON")
			if (!on)
				toggle()
				return 1
		if ("OFF")
			if (on)
				toggle()
				return 1
		if ("TOGGLE")
			toggle()
			return 1

	return 0


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
				transmitmessage(createmessagetomachine("SOUND", M))
	src.updateUsrDialog()

/obj/machinery/conveyor_control/updateicon()
	overlays = null
	overlays += image('conveyor.dmi', "cb-s[state]")

	if (stat & (NOPOWER|BROKEN))
		overlays += image('conveyor.dmi', "cb-p")

/obj/machinery/conveyor_control/power_change()
	..()
	updateicon()

/obj/machinery/conveyor_klaxon/process()
	if (stat & (NOPOWER|BROKEN))
		return
	use_power(5)
	if (src.on)
		use_power(10)

/obj/machinery/conveyor_klaxon/receivemessage(var/message, var/obj/machinery/srcmachine)
	if (..())
		return 1

	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)

	switch (commands[1])
		if ("SOUND")
			if (!on)
				soundwarning()
				return 1

	return 0

/obj/machinery/conveyor_klaxon/proc/soundwarning()
	if (src.on || stat & (NOPOWER|BROKEN))
		return
	src.on = 1
	view(5, src) << sound('sound/machinery/klaxon/3.wav', 0, 0, 3, 60)
	spawn(1) //Animation done in code to keep it aligned with the actual sound...  hopefully.
		src.icon_state = "klaxon1"
		sleep(5)
		src.icon_state = "klaxon0"
		sleep(7)
		src.icon_state = "klaxon1"
		sleep(5)
		src.icon_state = "klaxon0"
		sleep(7)
		src.icon_state = "klaxon1"
		sleep(5)
		src.icon_state = "klaxon0"
		sleep(20)
		src.on = 0