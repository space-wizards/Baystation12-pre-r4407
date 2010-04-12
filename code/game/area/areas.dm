/area
	var/datum/superarea/superarea = null
	var/fire = null
	var/atmos = 1
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"

	icon = 'areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	var/lightswitch = 1

	var/eject = null

	var/requires_power = 1
	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = 'music/space.ogg'
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/numturfs = 0
	var/linkarea = null
	var/area/linked = null
	var/no_air = null


/area/ConnectTo(var/area/A)
	src.superarea = A.superarea
	if (src.superarea)
		if (!(src in src.superarea.areas))
			src.superarea.areas += src


/area/engine/

/area/turret_protected/

/area/auto_protected/

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"
	music = ""

/area/admin
	name = "Admin room"
	icon_state = "start"
	music = ""

/area/arrival/shuttle
	name = "Arrival Shuttle"
	icon_state = "shuttle"
	music = ""

/area/shuttle
	sd_lighting = 0
	requires_power = 0
	name = "Escape Shuttle"
	icon_state = "shuttle"
	music = "music/ending.ogg"

/area/sydi_hq
	requires_power = 0
	name = "Sydicate C2A Sector HQ"
	icon_state = "shutte"
	music = ""

// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/shuttle_prison/  // referenced in shuttle.dm:57 and :86
	requires_power = 0
	name = "Prison Shuttle"
	icon_state = "shuttle"
	music = ""

/area/shuttle_supply/
	requires_power = 0
	name = "Supply Shuttle"
	icon_state = "shuttle"
	music = ""

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	sd_lighting = 0
	music = ""

// ===

/area/New()
	..()

	if (src.superarea) //Add this entire code block
		if (!(src in src.superarea.areas))
			src.superarea.areas += src
	else
		src.superarea = new /datum/superarea
		src.superarea.areas += src
	src.icon = 'alert.dmi'
	src.icon_state = "invi" //fix: stop atmos from having its icon_state match the one for the atmos alarm in alert.dmi
	src.layer = 10

	if(!requires_power)
		power_light = 1
		power_equip = 1
		power_environ = 1

	spawn(5)
		for(var/turf/T in src)		// count the number of turfs (for lighting calc)
			numturfs++				// spawned with a delay so turfs can finish loading
			if(no_air)
				T.oxygen = 0		// remove air if so specified for this area
				T.n2 = 0
				T.res_vars()

		if(linkarea)
			linked = locate(text2path("/area/[linkarea]"))		// area linked to this for power calcs


	spawn(15)
		src.power_change()		// all machines set to current power level, also updates lighting icon

/proc/get_area(area/A)
	while(!istype(A, /area) && A)
		A = A.loc
	return A

/area/proc/atmosalert(var/state, var/obj/machinery/alarm/source, var/super)

	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	for (var/mob/ai/aiPlayer in world)
		// maybe it'll just be easier to check the retval from trigger/cancel
		if (state == 0)
			// send off a trigger
			if (!super)aiPlayer.triggerAlarm("Atmosphere", src, cameras, source)
			atmos = 0
			src.updateicon()
		else if (state == 2)
			var/retval = !super && aiPlayer.cancelAlarm("Atmosphere", src, source)
			if (retval == 0) // alarm(s) cleared
				atmos = 1
			icon_state = "invi"
	if (super)
		return 1
	for (var/area/A in src.superarea.areas) //Propagate to the rest of the original area (The DAL library cuts up areas)
		if (A != src)
			A.atmosalert(state, source, 1)
	return 1

/area/proc/poweralert(var/state, var/source,var/super)
	if (state != poweralm)
		poweralm = state
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in src)
			cameras += C
		for (var/mob/ai/aiPlayer in world)
			if (state == 1)
				aiPlayer.cancelAlarm("Power", src, source)
			else
				aiPlayer.triggerAlarm("Power", src, cameras, source)
	if (super)
		return
	for (var/area/A in src.superarea.areas) //Propagate to the rest of the original area (The DAL library cuts up areas)
		A.poweralm = src.poweralm
	return

/area/proc/lockdown(var/super)

	if(src.name == "Space") //no fire alarms in space
		return
	src.updateicon()
	src.mouse_opacity = 0
	for(var/obj/machinery/door/firedoor/D in src)
		if(D.operating)
			D.nextstate = CLOSED
		else if(!D.density)
			spawn(0)
				D.closefire()
	if (super)
		return
	for (var/area/A in src.superarea.areas) //Propagate to the rest... you get the idea.
		if (A != src)
			A.lockdown(1)
	return

/area/proc/firealert(var/super)

	if(src.name == "Space") //no fire alarms in space
		return
	if (!( src.fire ))
		src.fire = 1
		src.updateicon()
		src.mouse_opacity = 0
		for(var/obj/machinery/door/firedoor/D in src)
			if(D.operating)
				D.nextstate = CLOSED
			else if(!D.density)
				spawn(0)
					D.closefire()
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in src)
			cameras += C
		for(var/obj/machinery/sprinkler/S in src)
			S.operating = 1
		for (var/mob/ai/aiPlayer in world)
			aiPlayer.triggerAlarm("Fire", src, cameras, src)
		if (super)
			return
		for (var/area/A in src.superarea.areas) //Propagate to the rest... you get the idea.
			if (A != src)
				A.firealert(1)
	return

/area/proc/lockdownreset(var/super)
	if (src.fire)
		return //Don't disable a lockdown if a fire has started
	src.mouse_opacity = 0
	src.updateicon()
	for(var/obj/machinery/sprinkler/S in src)
		S.operating = 0
	for(var/obj/machinery/door/firedoor/D in src)
		if(D.operating)
			D.nextstate = OPEN
		else if(D.density)
			spawn(0)
				D.openfire()
	if (super)
		return
	for (var/area/A in src.superarea.areas)
		if (A != src && A.fire == 1)
			A.lockdownreset(1)
	return

/area/proc/firereset(var/super)
	if (src.fire)
		src.fire = 0
		src.mouse_opacity = 0
		src.updateicon()
		for(var/obj/machinery/sprinkler/S in src)
			S.operating = 0
		for(var/obj/machinery/door/firedoor/D in src)
			if(D.operating)
				D.nextstate = OPEN
			else if(D.density)
				spawn(0)
					D.openfire()
		for (var/mob/ai/aiPlayer in world)
			aiPlayer.cancelAlarm("Fire", src, src)
		if (super)
			return
		for (var/area/A in src.superarea.areas)
			if (A != src && A.fire == 1)
				A.firereset(1)
	return

/area/proc/partyalert()
	if(src.name == "Space") //no fire alarms in space
		return
	if (!( src.party ))
		src.party = 1
		src.updateicon()
		src.mouse_opacity = 0
		for(var/obj/machinery/door/firedoor/D in src)
			if(D.operating)
				D.nextstate = CLOSED
			else if(!D.density)
				spawn(0)
					D.closefire()
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in src)
			cameras += C
	return

/area/proc/partyreset()
	if (src.party)
		src.party = 0
		src.mouse_opacity = 0
		src.updateicon()
		for(var/obj/machinery/door/firedoor/D in src)
			if(D.operating)
				D.nextstate = OPEN
			else if(D.density)
				spawn(0)
					D.openfire()
	return

/area/proc/updateicon()
	if (partysecret == 0)
		if ((fire || eject || party || !atmos) && power_environ)
			if(fire)
				icon_state = "blue"
			else if(eject)
				icon_state = "red"
			else if(!atmos)
				icon_state = "atmos"
			else if(party)
				icon_state = "party"
		else
			icon_state = "invi"
	else
		icon_state = "party"


/area/proc/light_switch()
	for (var/area/A in src.superarea.areas)
		A.lightswitch = src.lightswitch
		for (var/obj/machinery/light_switch/L in A)
			L.propagate()
	return



/area/proc/powered(var/chan)		// return true if the area has power to given channel
	if(!requires_power)
		return 1
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return 0

// called when power status changes

/area/proc/power_change(var/super)
/*
	for(var/obj/machinery/M in src)		// for each machine in the area
		M.power_change()				// reverify power status (to update icons etc.)

	spawn(rand(15,25))
		src.updateicon()

	if(linked)
		linked.power_equip = power_equip
		linked.power_light = power_light
		linked.power_environ = power_environ
		linked.power_change()*/

	for(var/obj/machinery/M in src)		// for each machine in the area
		M.power_change()				// reverify power status (to update icons etc.)

	spawn(rand(15,25))
		src.updateicon()

	if(linked)
		linked.power_equip = power_equip
		linked.power_light = power_light
		linked.power_environ = power_environ
		linked.power_change()

	if (super)
		return

	for (var/area/A in src.superarea.areas)
		if (A != src)
			A.power_equip = power_equip
			A.power_light = power_light
			A.power_environ = power_environ
			A.power_change(1)


/area/proc/usage(var/chan,var/super = 0)
/*
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ

	if(linked)
		return linked.usage(chan) + used
	else
		return used
*/
	var/used = 0

	switch(chan)
		if(LIGHT)
			used = used_light
		if(EQUIP)
			used = used_equip
		if(ENVIRON)
			used = used_environ
		if(TOTAL)
			used = used_light + used_equip + used_environ

	if (super)
		return used

	for (var/area/A in src.superarea.areas)
		if (A != src)
			used += A.usage(chan, 1)

	if(linked)
		return linked.usage(chan) + used
	else
		return used
/area/proc/clear_usage(var/super = 0)
/*
	if(linked)
		linked.clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0
*/
	if(linked)
		linked.clear_usage()

	used_equip = 0
	used_light = 0
	used_environ = 0

	if (super)
		return

	for (var/area/A in src.superarea.areas)
		if (A != src)
			A.clear_usage(1)

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

#define LIGHTING_POWER 8		// power (W) per turf used for lighting

/area/proc/calc_lighting()
	if(lightswitch && power_light)
		used_light += numturfs * LIGHTING_POWER