/obj/landmark/New()

	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

	if (name == "shuttle")
		shuttle_z = src.z
		del(src)
		return

	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y

	if (name == "monkey")
		monkeystart += src.loc
		del(src)
		return

	//prisoners
	if (name == "prisonwarp")
		prisonwarp += src.loc
		del(src)
	if (name == "mazewarp")
		mazewarp += src.loc
	if (name == "tdome1")
		tdome1	+= src.loc
	if (name == "tdome2")
		tdome2 += src.loc

	//not prisoners

	if (name == "prisonsecuritywarp")
		prisonsecuritywarp += src.loc
		del(src)
		return

	if (name == "blobstart")
		blobstart += src.loc
		del(src)
		return

	if(name == "Pod-Dock")
		poddocks += src.loc
		del(src)
		return

	if(name == "Pod-Spawn")
		podspawns += src.loc
		del(src)
		return

	//Multiple Z level support

	if(name == "Station-Floor")
		stationfloors += src.z
		del(src)
		return

	if(name == "Centcom-Floor")
		centcomfloors += src.z
		del(src)
		return

	if(name == "Station-Dock-Emerg")
		station_emerg_dock = src.z
		del(src)
		return

	if(name == "Station-Dock-Supply")
		station_supply_dock = src.z
		del(src)
		return

	if(name == "Station-Dock-Prison")
		station_prison_dock = src.z
		del(src)
		return

	if(name == "Station-Dock-Syndicate")
		station_syndicate_dock = src.z
		del(src)
		return

	if(name == "Centcom-Dock-Supply")
		centcom_supply_dock = src.z
		world.log << centcom_supply_dock
		del(src)
		return

	if(name == "Centcom-Dock-Emerg")
		centcom_emerg_dock = src.z
		shuttle_z = src.z
		del(src)
		return

	if(name == "Shuttle-Move-Z")
		shuttle_en_route_level = src.z
		del(src)
		return

	if(name == "Syndicate-Dock")
		syndicate_shuttle_dock = src.z
		del(src)
		return

	if(name == "Prison-Dock")
		prison_shuttle_dock = src.z
		del(src)
		return

	if(name == "Engine-Eject-Target")
		engine_eject_z_target = src.z
		del(src)
		return

	return

/obj/start/New()

	..()
	src.tag = text("start*[]", src.name)
	src.invisibility = 100
	return

/world/proc/update_stat()
	src.status = "Space Station 13";
	src.status += " ([SS13_version])"

	var/list/features = list()

	if (ticker && master_mode)
		features += master_mode
	else if (!ticker)
		features += "<b>STARTING</b>"
		src.status += ": [dd_list2text(features, ", ")]"
		return

	if (config && config.enable_authentication)
		features += "goon only"

	if (!enter_allowed)
		features += "closed"

	if (abandon_allowed)
		features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	if (host)
		features += "hosted by <b>[host]</b>"
	else if (config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		src.status += ": [dd_list2text(features, ", ")]"

var/map_loading = 1
/world/New()
	..()
	sd_SetDarkIcon('sd_dark_alpha7.dmi', 7)

	config = new /datum/configuration()
	config.load("config/config.txt")

	src.update_stat()

	sun = new /datum/sun()

	spawn(0)
		//----
		//Indent this block and add a line here
		//if, at a later date, run-time map loading
		//becomes a desired feature.
		//If you want the files, just ask.
		//The spawn() is important, as it allows the
		//rest of the world to be created since map
		//loading and the calculations after are
		//somewhat slow, so spawn()ing allows them
		//to occasionally sleep() to let the server run.

		//This line should only be used for testing the map loader,
		//as it is still worse at loading full maps than the default.
		//Still, uncomment it, uncheck the map for compiling, and
		//the map should still load just fine.

		//QML_loadMap("maps\\Bay Station 12 alpha.dmp",0,0,0)

		load_map_modules()
		sleep(10)
		map_loading = 0
		for (var/turf/T in world)
			T.updatelinks()
		makepipelines()
		powernets_building = 0
		makepowernets()
		makecomputernets()
		//----

	crban_loadbanfile()
	gen_access()
	crban_updatelegacybans()
	jobban_loadbanfile()
	jobban_updatelegacybans()
	LoadPlayerData()
	SavePlayerLoop()
	spawn(0)
		SetupOccupationsList()
		return
	var/list/L2 = list(1,2,3,4,5,6,7,8,9,10,11,12,13)
	for(var/i = 1, i<=20, i++)
		var/one = pick(L2)
		var/two = pick(L2)
		var/temp = L2[one]
		L2[one] = L2[two]
		L2[two] = temp
	BAD_VISION = L2[1]
	HULK = L2[2]
	HEADACHE = L2[3]
	STRANGE = L2[4]
	COUGH = L2[5]
	LIGHTHEADED = L2[6]
	TWITCH = L2[7]
	XRAY = L2[8]
	NERVOUS = L2[9]
	AURA = L2[10]
	ISBLIND = L2[11]
	TELEKINESIS = L2[12]
	DEAF = L2[13]

	for(var/i = 0, i<3, i++)
		zombie_genemask += 1<<rand(3*8)//3 blocks * 8 bits per block

	// ****stuff for presistent mode picking
	var/newmode = null

	var/modefile = file2text(persistent_file)

	if(modefile)			// stuff to fix trailing NL problems
		var/list/ML = dd_text2list(modefile, "\n")

		newmode = ML[1]

		//world << "Savefile: [SF] ([SF["newmode"]])"

		if(newmode)
			master_mode = newmode
			world.log << "Read default mode '[newmode]' from [persistent_file]"


	// *****
	var/motd = file2text("config/motd.txt")
	auth_motd = file2text("config/motd-auth.txt")
	no_auth_motd = file2text("config/motd-noauth.txt")
	if (motd)
		join_motd = motd

	var/ad_text = file2text("config/admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == ";")
				continue
			var/t1 = findtext(t, " - ", 1, null)
			if (t1)
				var/m_key = copytext(t, 1, t1)
				var/a_lev = copytext(t, t1 + 3, length(t) + 1)
				admins[m_key] = a_lev
				world.log << ("ADMIN: [m_key] = [a_lev]")

	// apply some settings from config..
	abandon_allowed = config.respawn

	vote = new /datum/vote()

	main_hud1 = new /obj/hud(  )
	main_hud2 = new /obj/hud/hud2(  )
	SS13_airtunnel = new /datum/air_tunnel/air_tunnel1(  )

	while(map_loading)
		sleep(10)

	nuke_code = text("[]", rand(10000, 99999.0))
	for(var/obj/machinery/nuclearbomb/N in world)
		if (N.r_code == "ADMIN")
			N.r_code = nuke_code

	plmaster = new /obj/overlay(  )
	plmaster.icon = 'plasma.dmi'
	plmaster.icon_state = "onturf"
	plmaster.layer = FLY_LAYER

	slmaster = new /obj/overlay(  )
	slmaster.icon = 'plasma.dmi'
	slmaster.icon_state = "sl_gas"
	slmaster.layer = FLY_LAYER

	cellcontrol = new /datum/control/cellular()
	spawn (0)
		cellcontrol.process()
		return

	src.update_stat()

	spawn (0)
		sleep(2400)		//*****RM was 900
		Label_482:
		if (going && (!ticker))
			ticker = new /datum/control/gameticker(  )
			spawn( 0 )
				ticker.process()
				return
			data_core = new /obj/datacore(  )
		else
			sleep(100)
			goto Label_482
		return
	worldsetup = 1
	world.log << "World Setup Complete"


/world/Reboot()
	if(no_end)
		world << "World end prevented. An administrator will have to enable world ending to allow automated restarts."
		return
	else
		..()

//Crispy fullban
/world/Del()
	SavePlayerData()
	for(var/mob/M in world)
		if(M.client)
			M << sound('sound/NewRound.ogg')
	sleep(10) // wait for sound to play
	..()

/world/Topic(T, addr, master, key)
	world.log << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if(T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x
	else if (T == "reboot" && master)
		world.log << "TOPIC: Remote reboot from master ([addr])"
		world << "Rebooting!  Initiated from master control"
		no_end = 0
		world.Reboot()
	else if(T == "players")
		var/n = 0
		for(var/mob/M in world)
			if(M.client)
				n++
		return n
	else if (T == "status")
		var/list/s = list()
		s["version"] = SS13_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		for(var/mob/M in world)
			if(M.client)
				s["player[n]"] = M.client.key
				n++
		s["players"] = n
		return list2params(s)

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/ai))
		return 1
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	spawn( 0 )
		if ((A && yes))
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set src in oview()

	if ((!( usr ) || !( isturf(usr.loc) )) || isarea(src))		// can't point to areas anymore
		return
	if (usr.stat == 0 && !usr.restrained())
		var/P = new /obj/point( (isturf(src) ? src : src.loc) )
		spawn(20)
			del(P)
			return
		for(var/mob/M in viewers(usr, null))
			M.show_message(text("<B>[]</B> points to []", usr, src), 1)
	return

/turf/proc/updatecell()
	return

/turf/proc/conduction()
	return

/turf/proc/cachecell()
	return

/datum/control/proc/process()
	return

/datum/control/gameticker/proc/meteor_process()
	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= shuttle_time_to_arrive)
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
					if (src.timeleft >= shuttle_time_to_arrive)
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
	if (z_level != 1)
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
			U.poison = T.poison
			U.co2 = T.co2
			U.buildlinks()
			del(T)
		src.timeleft = shuttle_time_in_station
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
						U.poison = T.poison
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

// *****
// MAIN LOOP OF PROGRAM
// *****

var/main_tick = 0
var/update_state = 0

/datum/control/cellular/process()
	set invisibility = 0
	set background = 1
	var/supplytime = 0

	for(var/obj/machinery/light/L in world)
		L.process()

	Label_6:
	main_tick++

	update_state = main_tick % 4

	while(!( ticker ))
		for(var/mob/M in world)
			spawn( 0 )
				if(!M)
					return
				M.UpdateClothing()
				return
		sleep(10)
		updateap(1)

	time = (++time %10)
	supplytime = (++supplytime % 100)

	updateap()

	for(var/T in poddocks)
		for(var/obj/O in T)
			if (istype(O, /obj/machinery/vehicle))
				var/obj/machinery/vehicle/V = O
				V.anchored = 1
				poddocks -= T
				spawn(10)
					var/obj/machinery/door/poddoor/P = locate(/obj/machinery/door/poddoor) in get_step(T, NORTH)
					P.closepod()
					P = locate(/obj/machinery/door/poddoor) in get_step(T, SOUTH)
					sleep(30)
					P.openpod()

	if (!supplytime && supply_shuttle_points < 75)
		supply_shuttle_points += 1

	sun.calc_position()

	if(time%air_cycle == 0)
		spawn(-1)
			for(var/turf/space/space in world)
				if (space.updatecell && space.update_again)
					space.exchange()
					space.updatecell()
					sleep(0)
			return

	for(var/turf/station/T in world)
		if (T.updatecell && (T.update_again || T.firelevel >= 100000.0))
			T.exchange()
			T.updatecell()
			if(!time)
				T.conduction()
	sleep(3)
	for(var/mob/M in world)
		spawn( 0 )
			if(!M)
				return
			M.Life()
			return
	sleep(3)
	for(var/obj/move/S in world)
		S.process()
	sleep(2)
	for(var/obj/machinery/M in machines)
		M.process()

	for(var/obj/machinery/M in gasflowlist)
		M.gas_flow()

	for(var/datum/powernet/P in powernets)
		P.reset()

	src.var_swap = !( src.var_swap )
	if (src.processing)
		sleep(2)
		goto Label_6
	world.log <<"\red <B>PROCESSING STOPPED"
	return