/obj/machinery/spaceheater/New()
	..()

	switch(dir)
		if(1)
			pixel_y += 32
		if(2)
			pixel_y -= 26
		if(4)
			pixel_x += 26
		if(8)
			pixel_x -= 26

	dir = SOUTH
	icon_state = "spaceheater"

/obj/machinery/thermostat/New()
	..()
	name = "Thermostat"

/obj/machinery/spaceheater/process()
	if (stat & (NOPOWER|BROKEN|POWEROFF))
		return

	//TODO move this into a proc for all objects, so anything can produce heat

	use_power(120 * maxoutput)

	var/turf/T = src.loc
	var/temp = T.temp() - T0C

	if (temp >= maxheat)
		return

	var/ratemult = 1
	var/P = T.zone.pressure()

	if (P < 100)
		P = 100 - P
		ratemult = (P * P) / 10000
		ratemult = 1 - ratemult
	else if (P > 100)
		ratemult = 100 / P

	ratemult *= maxoutput

	var/newtemp = temp + (ratemult / T.zone.contents.len)

	if (newtemp < maxheat) //Heaters can't put out more heat than this
		T.temp_set(newtemp + T0C)
	else if (newtemp > maxheat)
		T.temp_set(maxheat + T0C)

/obj/machinery/spaceheater/receivemessage(var/message, var/obj/machinery/srcmachine)
	if (..())
		return 1

	var/list/commands = dd_text2list(uppertext(stripnetworkmessage(message)), " ", null)
	if(commands.len < 3 || commands[1] != "HEATERS")
		return
	var/area/A = get_area(loc)
	if (commands[2] != A.superarea.areaid)
		return
	switch(commands[3])
		if ("ON")
			stat &= ~POWEROFF
			return 1
		if ("OFF")
			stat |= POWEROFF
			return 1

	return 0

/obj/machinery/thermostat/UIinput(var/C as text)
	switch (C)
		if("T-Up")
			target += 0.5
			if (target > 500)
				target = 500
		if("T-Dn")
			target -= 0.5
			if (target < 0)
				target = 0
		if("Pwr")
			stat ^= POWEROFF
	UIUpdate(usr.client)

/obj/machinery/thermostat/process()
	if (stat & (NOPOWER|BROKEN))
		return

	var/area/A = get_area(src)

	//If heaters are currently on and the unit is set to disable heating...
	if (on && (stat & POWEROFF))
		transmitmessage(createmulticast("000", gettypeid(/obj/machinery/spaceheater), "HEATERS [A.superarea.areaid] OFF"))
		on = 0
		return

	//Should we alter the state of the heaters power?
	var/turf/T = get_turf(src)
	var/temp = T.temp - T0C
	var/want = (temp < (target - 1) ? 1 : (temp > (target + 1) ? -1 : 0))

	if (want == 0) //No?  Return
		return

	var/newstate = (want == 1) //Should they be on or off?

	if (newstate == on) //Has their state actually changed?
		return

	if (newstate)
		transmitmessage(createmulticast("000", gettypeid(/obj/machinery/spaceheater), "HEATERS [A.superarea.areaid] ON"))
	else
		transmitmessage(createmulticast("000", gettypeid(/obj/machinery/spaceheater), "HEATERS [A.superarea.areaid] OFF"))

	on = newstate //And store what the 'stat thinks

/obj/machinery/thermostat/UIUpdate(var/client/C)
	var/turf/T = get_turf(src)
	winset(C, "mac_thermostat_win.lblCurrentTemp", "text=\"Current Temperature: [round(T.temp() - T0C, 0.1)]°C\"")
	winset(C, "mac_thermostat_win.lblSetTemp", "text=\"Set Temperature: [target]°C\"")
	winset(C, "mac_thermostat_win.lblHeatersOn", "is-visible=\"[on ? "true" : "false"]\"")
	winset(C, "mac_thermostat_win.lblOff", "is-visible=\"[(stat & POWEROFF) ? "true" : "false"]\"")
	return

/obj/machinery/thermostat/attack_hand(var/mob/M as mob)
	if (..())
		return

	if (!M.client)
		return
	UIUpdate(M.client)
	winshow(M.client, "mac_thermostat")
	M.machine = src

/obj/machinery/thermostat/attack_ai(var/mob/ai/M)
	return attack_hand(M)

/obj/machinery/thermostat/attack_paw(var/mob/M)
	return attack_hand(M)