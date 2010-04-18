/mob/observer/New(mob/corpse)
	set invisibility = 101
	src.corpse		= corpse
	src.loc			= corpse.loc
	src.name		= corpse.name
	src.sight |= SEE_TURFS | SEE_MOBS | SEE_INFRA | SEE_OBJS
	src.see_invisible = 100
	src.see_infrared = 100
	src.see_in_dark = 100
	src.verbs += /mob/observer/proc/Teleport
	src.verbs += /mob/observer/proc/turningback
/mob/
	var/oldmob
/mob/observer/proc/turninghost()
	set name = "Turn into ghost"
	set desc = "You cannot be revived as a ghost"
	if(src.client && src.dead())
		src.oldckey = client.ckey
		src.oldmob = client.mob
		src.client.mob = new/mob/observer(src)
	return
/mob/observer/proc/turningback()
	set name = "Return to your body"
	if(src.client && src.dead())
		src.client.mob = src.oldmob
		src.client.ckey = src.oldckey
	return
/mob/observer/Move(NewLoc, direct)
	if(NewLoc)
		src.loc = NewLoc
		return
	if(direct & NORTH)	src.y++
	if(direct & SOUTH)	src.y--
	if(direct & EAST)	src.x++
	if(direct & WEST)	src.x--

/mob/observer/examine()
	if(usr)	usr << src.desc

/mob/observer/can_use_hands()	return 0
/mob/observer/is_active()		return 0

/mob/observer/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		if(ticker)
			var/timel = ticker.timeleft
			stat(null, text("ETA-[]:[][]", timel / 600 % 60, timel / 100 % 6, timel / 10 % 10))
		if(ticker.mode.name == "Corporate Restructuring" && ticker.target)
			var/icon = ticker.target.name
			var/icon2 = ticker.target.rname
			var/area = get_area(ticker.target)
			stat(null, text("Target: [icon2] (as [icon]) is in [area]"))
		if(ticker.mode.name == "AI malfunction" && ticker.processing)
			stat(null, text("Time until all SS13's systems are taken over: [(ticker.AIwin - ticker.AItime) / 600 % 60]:[(ticker.AIwin - ticker.AItime) / 100 % 6][(ticker.AIwin - ticker.AItime) / 10 % 10]"))

	return

/mob/observer/proc/Teleport(var/area/A in world)
	set name = "Teleport"
	set desc = "Teleport somewhere"

	var/list/listA = list()

	for(var/turf/B in A)
		listA += B
	usr << "\blue Jumping to [A]!"
	usr.loc = pick(listA)