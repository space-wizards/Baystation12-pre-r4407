//TODO clean up this file and potentially move the functions into more appropriate game modes

/datum/control/gameticker/proc/meteor_process()
	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= SHUTTLE_TIME_TO_ARRIVE)
						src.timeleft = null
						src.timing = 0
		for(var/i = 0; i < 10; i++)
			spawn_meteors()
		if (src.timeleft <= 0 && src.timing)
			if(!roundover)
				src.timeup()
			else
				check_win()

		sleep(10)
	while(src.processing)
	return


/datum/control/gameticker/proc/extend_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= SHUTTLE_TIME_TO_ARRIVE)
						src.timeleft = null
						src.timing = 0
		if (prob(0.5))
			spawn_meteors()
		if (src.timeleft <= 0 && src.timing)
			if(!roundover)
				src.timeup()
			else
				check_win()

		sleep(10)
	while(src.processing)
	return

/datum/control/gameticker/proc/malfunction_process()
	do
		if(ticker.AItime == ticker.AIwin)
			return
		ticker.AItime += 10
		sleep(10)
		if (ticker.AItime == 6000)
			world << "<FONT size = 3><B>Cent. Com. Update</B> AI Malfunction Detected</FONT>"
			world << "\red It seems we have provided you with a malfunctioning AI. We're very sorry."
	while(src.processing)
	return

/datum/control/gameticker/proc/nuclear(z_level)
	if (src.mode != "nuclear emergency")
		return
	if (!(z_level in stationfloors))
		return
	spawn( 0 )
		src.objective = "Success"
		world << "<B>The Syndicate Operatives have destroyed Space Station 13!</B>"
		for(var/mob/human/H in world)
			if ((H.client && findtext(H.rname, "Syndicate ", 1, null)))
				if (H.stat != 2)
					world << text("<B>[] was []</B>", H.key, H.rname)
				else
					world << text("[] was [] (Dead)", H.key, H.rname)
		src.timing = 0
		sleep(300)
		world.log_game("Syndicate success")
		world.Reboot()
		return
	return

/datum/control/gameticker/proc/timeup()

	var/area/B = locate(/area/shuttle)
	if (src.shuttle_location == centcom_emerg_dock)

		var/list/srcturfs = list()
		var/list/dstturfs = list()
		var/throwx = 0
		for (var/area/A in B.superarea.areas)
			for(var/turf/T in A)
				if (T.z == centcom_emerg_dock)
					srcturfs += T
				else
					dstturfs += T
				if(T.x > throwx)
					throwx = T.x
		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(throwx, T.y, T.z)
			var/turf/E = get_step(D, EAST)
			for(var/atom/movable/AM as mob|obj in T)
				// east! the mobs go east!
				AM.Move(D)
				spawn(0)
					AM.throw_at(E, 1, 1)
					return

		for(var/turf/T in srcturfs)
			for(var/atom/movable/AM as mob|obj in T)
				// first of all, erase any non-space turfs in the area
				var/turf/U = locate(T.x, T.y, T.z)
				if(!istype(T, /turf/space))
					var/turf/space/S = new /turf/space( locate(U.x, U.y, U.z) )
					B.contents -= S
					B.contents += S
				AM.z = station_emerg_dock
			var/turf/U = locate(T.x, T.y, T.z)
			U.oxygen = T.oxygen
			U.poison = T.poison()
			U.co2 = T.co2
			U.buildlinks()
			del(T)
		src.timeleft = SHUTTLE_TIME_IN_STATION
		src.shuttle_location = station_emerg_dock
		world << "<B>The emergency shuttle has docked with the station! You have [ticker.timeleft/600] minutes to board the shuttle.</B>"
	else
		world << "<B>The emergency shuttle is leaving!</B>"
		shuttleleft = 1
		check_win()
	return

/datum/control/gameticker/proc/check_win()
	roundover = 1
	if (!mode.check_win())
		return

	for (var/mob/ai/aiPlayer in world)
		if (aiPlayer.stat!=2)
			world << "<b>[aiPlayer.name]'s laws at the end of the game were:</b>"
		else
			world << "<b>[aiPlayer.name]'s laws when it was deactivated were:</b>"
		aiPlayer.showLaws(1)

	if(!nuclearend) //The shuttle exploded if the round ended due to nuclear, so don't move it back to centcom
		var/area/B = locate(/area/shuttle) //Move shuttle to CentCom if it's on the station
		if (src.shuttle_location == station_emerg_dock) //Altered to support superareas.
			for (var/area/A in B.superarea.areas) //replace station_z and shuttle_z with the correct values
				for(var/turf/T in A)
					if (T.z == station_emerg_dock)
						for(var/atom/movable/AM as mob|obj in T)
							AM.z = centcom_emerg_dock
						var/turf/U = locate(T.x, T.y, centcom_emerg_dock)
						U.oxygen = T.oxygen
						U.poison = T.poison()
						U.co2 = T.co2

						U.buildlinks()
						del(T)
	sleep(300)
	world.log_game("Rebooting due to end of game")
	world.Reboot()
	return 1

/datum/control/gameticker/process()

	shuttle_location = shuttle_z

	world.update_stat()
	world << "<B>Welcome to the Space Station 13!</B>\n\n"

	switch (master_mode)
		if("secret")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Secret!</B>"
			world << "<B>The game will pick between whatever modes the admin set!</B>"
		if("random")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Random</B>"
			world << "<B>The game has picked mode: \red [src.mode.name]</B>"
		else
			src.mode = config.pick_mode(master_mode)
			if (!src.mode)
				world << "<B>\red Failed to pick a game mode!</B>"
				world << "\blue Restart the world, or enjoy a round of extended."
				src.mode = config.pick_mode("extended")
			src.mode.announce()

	src.mode.pre_setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("starting game of [src.mode.name]")

	DivideOccupations()

	for (var/obj/manifest/M in world)
		M.manifest()

	for (var/mob/human/H in world)
		if (H.start) //dnamarker1
			reg_dna[H.primary.uni_identity] = H.name

	data_core.manifest()

	src.mode.post_setup()

	for(var/obj/start/S in world)
		//Deleting Startpoints but we need the ai point to AIize people later
		if (S.name != "AI")
			del(S)
			continue
		S.icon_state = null
