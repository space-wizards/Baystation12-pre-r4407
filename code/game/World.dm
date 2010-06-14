// **********************************
// New (World)
// ------------
//  Generates the world and sets up all the
//  information needed for the world to run
// **********************************

/world/New()
	..()
	sd_SetDarkIcon('sd_dark_alpha7.dmi', 7)

	config = new /datum/configuration()
	config.load("config/config.txt")

	//Update the world information
	update_stat()

	//Create the sun
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
			T.checkfire = (T.x % 2 && T.y % 2)
		makepipelines()
		powernets_building = 0
		makepowernets()
		makecomputernets()
		getdb()
		LoadAdmins()
		sleep(2)
		world.log << "World Setup Complete, join when ready"
		//----

	//Generate the access and passwords data
	gen_access()

	//TODO this needs to be moved out of here and into the MySQL stuff
	//Load the job bans.  Unlike normal bans, these are still stored per-server
	jobban_loadbanfile()

	//Load player data..  a local cache of the MySQL tables?
	LoadPlayerData()

	SavePlayerLoop()

	spawn(0)
		SetupOccupationsList()
		return

	//Configure Genetics and zombie information
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
	ISNERVOUS = L2[9]
	AURA = L2[10]
	ISBLIND = L2[11]
	TELEKINESIS = L2[12]
	ISDEAF = L2[13]

	for(var/i = 0, i<3, i++)
		zombie_genemask += 1<<rand(3*8)//3 blocks * 8 bits per block


	//Persistent Mode Handling
	var/newmode = null
	var/modefile = file2text(persistent_file)
	if(modefile) //If the mode file exists...
		var/list/ML = dd_text2list(modefile, "\n")
		newmode = ML[1]
		if(newmode)
			master_mode = newmode
			world.log << "Resuming last mode ([newmode])"


	//Load the MoTDs
	var/motd = file2text("config/motd.txt")
	auth_motd = file2text("config/motd-auth.txt")
	no_auth_motd = file2text("config/motd-noauth.txt")
	if (motd)
		join_motd = motd

	//Apply config settings as needed
	abandon_allowed = config.respawn

	//Init voting control
	vote = new /datum/vote()

	//Set up the HUD masters
	main_hud1 = new /obj/hud(  )
	main_hud2 = new /obj/hud/hud2(  )

	//Wait for the map to load completely
	while(map_loading)
		sleep(10)

	//Set up the nukes
	nuke_code = text("[]", rand(10000, 99999.0))
	for(var/obj/machinery/nuclearbomb/N in world)
		if (N.r_code == "ADMIN")
			N.r_code = nuke_code

	//Set up the graphic overlays for atmospheric effects

	//Plasma
	plmaster = new /obj/overlay(  )
	plmaster.icon = 'plasma.dmi'
	plmaster.icon_state = "onturf"
	plmaster.layer = FLY_LAYER

	//Anesthetic
	slmaster = new /obj/overlay(  )
	slmaster.icon = 'plasma.dmi'
	slmaster.icon_state = "sl_gas"
	slmaster.layer = FLY_LAYER

	//Create and start the ticker
	cellcontrol = new /datum/control/cellular()
	spawn() cellcontrol.process()

	//Set up the world description on the hub
	update_stat()

    //Spawn the game-starting proc
	spawn (2400) //Wait 4 minutes
		if (ticker) //If the game was automatically started, cancel
			return
		while (!going) //Wait longer if the game start has been delayed
			sleep(100)
		if (!ticker) //If the game hasn't started, start it.
			ticker = new /datum/control/gameticker(  )
			spawn( 0 )
				ticker.process()
				return
			data_core = new /obj/datacore(  )
			return

	worldsetup = 1

// **********************************
// Update_Stat (World)
// ------------
//  Updates the game status on the SS13 hub
// **********************************

/world/proc/update_stat()
	src.status = "Space Station 13"
	src.status += " ([SS13_version])"

	var/list/features = list()

	if (ticker && master_mode)
		features += master_mode
	else if (!ticker)
		features += "<b>STARTING</b>"

	if (config && config.enable_authentication)
		features += "Invite only"

	if (!enter_allowed)
		features += "Closed"

	if (abandon_allowed)
		features += abandon_allowed ? "Respawn" : "No respawn"

	if (config && config.allow_vote_mode)
		features += "Voting"

	if (config && config.allow_ai)
		features += "AI"

	features += "hosted by <b>[config.hostedby]</b>"

	src.status += ": [dd_list2text(features, ", ")]"


// **********************************
// Reboot (World)
// ------------
//  Reboots the world, unless no_end is nonzero
// **********************************

/world/Reboot()
	if(no_end)
		world << "World end prevented. An administrator will have to enable world ending to allow automated restarts."
		return
	else
		..()

// **********************************
// Del (World)
// ------------
//  Signals the end of round, then deletes the world
// **********************************

/world/Del()
	SavePlayerData()
	for(var/mob/M in world)
		if(M.client)
			M << sound('sound/NewRound.ogg')
	sleep(10) //Let the sound finish playing
	..()

// **********************************
// Topic (World)
// ------------
//  Handles interserver communication and teleport, status info, and remote management
// **********************************

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
	else if(T == "teleplayer")
        //download and open savefile
		var/savefile/F = new(Import())
        //load mob
		var/mob/M
		var {saved_x; saved_y; saved_z}
		F["s_x"] >> saved_x
		F["s_y"] >> saved_y
		F["s_z"] >> saved_z
		F["mob"] >> M
		M.Move(locate(saved_x,saved_y,saved_z))
		return 1
	else if(T == "teleping")
		if(ticker)
			return 1
		return 2
	return

/datum/control/proc/process()
	return

