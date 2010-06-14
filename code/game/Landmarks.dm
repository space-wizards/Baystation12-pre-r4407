
//Start locations for the occupations
/obj/start/New()
	..()
	src.tag = text("start*[]", src.name)
	src.invisibility = 100
	return

//Landmarks used for game information
/obj/landmark/New()
	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

	//Where the titular monkey can start in that game mode
	if (name == "monkey")
		monkeystart += src.loc
		del(src)
		return

	//Where in the map people warped to the prison station as prisoners can end up
	if (name == "prisonwarp")
		prisonwarp += src.loc
		del(src)

	//Where in the Maze people can end up as a starting position
	if (name == "mazewarp")
		mazewarp += src.loc

	//Spawn points for the two thunderdome teams
	if (name == "tdome1")
		tdome1	+= src.loc
	if (name == "tdome2")
		tdome2 += src.loc

	//Where in the map people warped to the prison as employees and not inmates can end up
	if (name == "prisonsecuritywarp")
		prisonsecuritywarp += src.loc
		del(src)
		return

	//Where in the map The Blob might start
	if (name == "blobstart")
		blobstart += src.loc
		del(src)
		return


	//********************************
	//Escape Pod support
	//********************************

	//Pod Spawn point.
	//Place this 20 or so tiles NORTH of an escape pod dock in centcom or elsewhere.
	if(name == "Pod-Spawn")
		podspawns += src.loc
		del(src)
		return
	//Pod Dock point
	//Place this in the middle of a pod dock in order to have it properly accept escape pods.
	//Have one open pod door to the north and one closed one to the south.  When a pod enters the north door and lands
	//On this tile, it'll stop due to the south door.  The game wil automatically close the north door and open the south one.
	//After air has entered the lock from the south, the player can leave the pod and figure out where they are.
	if(name == "Pod-Dock")
		poddocks += src.loc
		del(src)
		return


	//********************************
	//Multiple Z level support
	//********************************


	//Place a landmark with this name on any Z-level which contains a part of the station.
	//You are recommended not to mix Z-levels from different areas of the game, as it would present the possibility that
	//someone could jetpack from the station to centcom, for example (or to anywhere else).
	if(name == "Station-Floor")
		stationfloors += src.z
		del(src)
		return

	//Same as above, but for Centcom instead
	if(name == "Centcom-Floor")
		centcomfloors += src.z
		del(src)
		return

	//Which Z-Level the emergency shuttle will move to when it docks at the station
	if(name == "Station-Dock-Emerg")
		station_emerg_dock = src.z
		del(src)
		return

	//Which Z-Level the supply shuttle will move to when it docks at the station
	if(name == "Station-Dock-Supply")
		station_supply_dock = src.z
		del(src)
		return

	//Which Z-Level the prison shuttle will move to when it docks at the station
	if(name == "Station-Dock-Prison")
		station_prison_dock = src.z
		del(src)
		return

	//Which Z-Level the prison shuttle will move to when it docks at the station
	if(name == "Station-Dock-Syndicate")
		station_syndicate_dock = src.z
		del(src)
		return

	//Which Z-Level the supply shuttle will move to when it docks at centcom
	if(name == "Centcom-Dock-Supply")
		centcom_supply_dock = src.z
		del(src)
		return

	//Which Z-Level the emergency shuttle will move to when it docks at centcom
	//The Emergency shuttle is assumed to also be at this point at the start of a round
	if(name == "Centcom-Dock-Emerg")
		centcom_emerg_dock = src.z
		shuttle_z = src.z
		del(src)
		return

	//which Z-Level all shuttles will move to for their "in-transit" state, if they have one
	if(name == "Shuttle-Move-Z")
		shuttle_en_route_level = src.z
		del(src)
		return

	//Which Z-Level the syndicate shuttle will move to when it reaches the syndicate station
	if(name == "Syndicate-Dock")
		syndicate_shuttle_dock = src.z
		del(src)
		return

	//Which Z-Level the prison shuttle will move to when it reaches the prison station
	if(name == "Prison-Dock")
		prison_shuttle_dock = src.z
		del(src)
		return

	//Which Z-Level the engine block in the station will be moved to upon ejection
	//Note that a multi-Z-level engine will be compressed into a single z-level at this time
	if(name == "Engine-Eject-Target")
		engine_eject_z_target = src.z
		del(src)
		return

	return