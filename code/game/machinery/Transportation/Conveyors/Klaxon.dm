
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