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
		hear_sound(sound('sound/machinery/conveyor/start.wav', 0, 0, 2, 50), 4)
	else
		hear_sound(sound('sound/machinery/conveyor/stop.wav', 0, 0, 2, 50), 4)
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

