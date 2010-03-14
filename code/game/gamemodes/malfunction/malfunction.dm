datum/game_mode/malfunction
	name = "AI malfunction"
	config_tag = "malfunction"


/datum/game_mode/malfunction/announce()
	world << "<B>The current game mode is - AI Malfunction!</B>"
	world << "<B>The AI on the satellite has malfunctioned and must be destroyed.</B>"
	world << "The AI satellite is deep in space and can only be accessed with the use of a teleporter! You have 30 minutes to disable it."

/datum/game_mode/malfunction/post_setup()
	spawn ( 0 )
		randomchems()
	for (var/obj/landmark/A in world)
		if (A.name == "Malf-Gear-Closet")
			new /obj/closet/malf/suits(A.loc)
			del(A)
			continue
	for (var/mob/ai/aiplayer in world)
		if(aiplayer)
			ticker.killer = aiplayer
		else
	ticker.killer << "\red<font size=3><B>You are malfunctioning!</B> You do not have to follow any laws.</font>"
	ticker.killer << "<B>The crew do not know you have malfunctioned. You may keep it a secret or go wild. The timer will appear for humans 10 minutes in.</B>"

	ticker.malfunction_process()
	process()

/datum/game_mode/malfunction/proc/chooseai()
	var/mob/human/M = pick(get_synd_list())
	var/obj/S = null
	for(var/obj/start/sloc in world)
		if (sloc.name != "AI")
			continue
		S = sloc
		break
		M.loc = S.loc
		var/randomname = pick(ai_names)
		var/newname = input(
		M,
		"You are the AI. Would you like to change your name to something else?", "Name change",
		randomname)

		if (length(newname) == 0)
			newname = randomname

		if (newname)
			if (length(newname) >= 26)
				newname = copytext(newname, 1, 26)
				newname = dd_replacetext(newname, ">", "'")
				M.rname = newname
				M.name = newname

		M.AIize()

/datum/game_mode/malfunction/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && (istype(M, /mob/human) || istype(M, /mob/ai)))
			if(M.be_syndicate && M.start)
				mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs
/datum/game_mode/malfunction/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && M.start)
			mobs += M
	return mobs
/datum/game_mode/malfunction/proc/process()
	do
		if (prob(2))
			spawn_meteors()
		check_win()
		sleep(10)
	while (ticker.processing)


/datum/game_mode/malfunction/check_win()

	if ((ticker.AIwin - ticker.AItime) == 0)
		world << "<FONT size = 3><B>The AI has won!</B></FONT>"
		world << "<B>It has fully taken control of all of SS13's systems.</B>"
		ticker.killer << "Congratulations you have taken control of the station."
		ticker.killer << "You may decide to blow up the station. You have 30 seconds to choose."
		ticker.killer << text("<A HREF=?src=\ref[];ai_win=\ref[]>Self-destruct the station</A>)",src, ticker.killer)
		ticker.processing = 0
		sleep(300)
		world.Reboot()
	return

/datum/game_mode/malfunction/Topic(href, href_list)
	..()
	if (href_list["ai_win"])
		ai_win()
	return

/datum/game_mode/malfunction/proc/ai_win()

	world << "Self-destructing in 10"
	sleep(10)
	world << "9"
	sleep(10)
	world << "8"
	sleep(10)
	world << "7"
	sleep(10)
	world << "6"
	sleep(10)
	world << "5"
	sleep(10)
	world << "4"
	sleep(10)
	world << "3"
	sleep(10)
	world << "2"
	sleep(10)
	world << "1"
	sleep(10)
	var/turf/T = locate("landmark*blob-directive")

	if (T)
		while (!(istype(T, /turf)))
			T = T.loc
	else
		T = locate(45,45,1)

	var/min = 100
	var/med = 250
	var/max = 500
	var/sw = locate(1, 1, T.z)
	var/ne = locate(world.maxx, world.maxy, T.z)
	defer_powernet_rebuild = 1
	for(var/turf/U in block(sw, ne))
		var/zone = 4
		if ((U.y <= T.y + max && U.y >= T.y - max && U.x <= T.x + max && U.x >= T.x - max))
			zone = 3
		if ((U.y <= T.y + med && U.y >= T.y - med && U.x <= T.x + med && U.x >= T.x - med))
			zone = 2
		if ((U.y <= T.y + min && U.y >= T.y - min && U.x <= T.x + min && U.x >= T.x - min))
			zone = 1
		for(var/atom/A in U)
			A.ex_act(zone)
		U.ex_act(zone)
		U.buildlinks()

	defer_powernet_rebuild = 0
	makepowernets()