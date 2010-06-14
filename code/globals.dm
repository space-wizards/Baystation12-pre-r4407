//********************************
//********************************
//
//		GLOBAL GAME VARIABLES
//
//********************************
//********************************

var
	// **********************************
	//	World Setup
	// **********************************

	//1 if the map is still loading during initial setup
	map_loading = 1

	//Server configuration
	datum/configuration/config = null

	//Player savefile version.  Mostly outdated because of the MySQL tables
	savefile_ver = "3"

	//What date and time the round started
	date = time2text(world.realtime,"DD-MM-YY")
	time2 = time2text(world.realtime,"hh-mm")

	//If the world has finished setting up
	worldsetup = 0

	//When this is 1, pulling someone will ALWAYS cause blood to be
	//spread around regardless of whether the pullee is injured or not
	BLOOD_FOR_THE_BLOOD_GOD = 0

	// **********************************
	//	Round Management
	// **********************************

	//Whether the round can start or not
	going = 1

	//When the world can reboot
	//0 = Reboot normally
	//1 = Reboot only on force, no-players-alive, and vote.
	//2 = Reboot only when forced by an admin or the remote master
	no_end = 0

	//What mode the round will be
	master_mode = "extended"

	//Whether you can abandon your mob and respawn
	abandon_allowed = 1

	//Whether you are allow to join a round in progress
	enter_allowed = 1

	//If the shuttle is frozen and not moving
	//Implemented but not used
	shuttle_frozen = 0

	//If the round has ended
	roundover = 0

	//If the round has ended due to a nuclear explosion
	nuclearend = 0

	//The station state at round start.
	//Used to determine how much of the station has been destroyed/etc
	//e.g. for Blob mode
	datum/station_state/start_state = null

	//Whether OOC is allowed for non-admins
	ooc_allowed = 1

	//Voting handler
	datum/vote/vote = null

	//The activation code for any nuclear devices in the world
	nuke_code = null

	//Allow random illnesses (TODO more info on these)
	random_illnesses = 1

	//Zombie mode stuff
	zombiewin = 0
	zombieshuttle = 0
	list/humans_left_lol = ""
	list/zombies_left_lol = ""

	//If the emergency shuttle has left, for reference during the check-win stage of each game mode
	shuttleleft = 0

	//Whether to allow large-temperature bombs to cause damage
	allowbigbombs = 1

	//Whether the short-range (vox) radios work
	shortradio = 1

	//Whether or not the Comm dish is aligned to centcom
	longradio = 1

	//Angle relative to the station the dish needs to be near in order to connect to centcom
	home = 256

	//Whether the station has lost power
	powerfailure = 0

	//The traitor's goal
	goal_killer = ""


	// **********************************
	//	Infrastructure
	// **********************************

	//Overlays masters for atmospheric effects
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null

	//The persistent mode file
	persistent_file = "data/mode.txt"

	//The medals information filename.  Deprecated?
	medals_file = "data/medals.txt"

	//Which filename to use for the round's log file
	log_file = "logs/[date]-log.txt"

	//The controller for engine ejection
	datum/engine_eject/engine_eject_control = null

	//Time between checks of the air system?
	air_cycle = 5

	//TODO why are these two not defines?
	// multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
	CELLRATE = 0.002
	// Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)
	CHARGELEVEL = 0.001

	//Escape pod warp and check locations.
	//See Landmarks.dm
	list/podspawns = list( )
	list/poddocks = list( )

	//The HUD objects
	obj/hud/main_hud1 = null
	obj/hud/hud2/main_hud2 = null

	//Some sort of var to ensure everyone has different DNA?
	dna_ident = 1

	//The four cardinal directions
	list/cardinal = list( NORTH, SOUTH, EAST, WEST )



	// **********************************
	//	Metagame Information
	// **********************************

	//What version of SS13 this is
	SS13_version = "Bay Station 12, latest updates"

	//Percentage chance an event will happen roughly every few minutes
	eventchance = 1

	//?
	event = 0

	//If an event has happened this round
	hadevent = 0

	//1 if a blob is in play
	blobevent = 0

	//Where the blob can start
	list/blobstart = list()

	//All the blob sections in play
	list/blobs = list()

	//Central object for managing in-game data for medical and security records
	obj/datacore/data_core = null

	//Registered DNA sequences at the start of the round.
	//Why this isn't in the datacore I don't know.
	//Should probably be moved there.
	list/reg_dna = list(  )

	//Where the monkey can start in the Monkey game mode
	list/monkeystart = list()


	// **********************************
	//	Administration
	// **********************************

	//Who has handled a bomb.  Not necessarily operating one, just holding it
	list/bombers = list(  )

	//keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
	list/lastsignalers = list(	)

	//All the administrators, from MySQL and config.hostedby
	list/datum/admininfo/admins = list( )

	//If admins are allowed to play sounds to all the players
	//There are also individual-level flags for this
	canplaysound = 1

	//Where prisoners on the prison station are warped to
	list/prisonwarp = list()

	//Where unsuspecting chumps get warped to if they're sent to the maze
	list/mazewarp = list()

	//Spawn point lists for the thunderdome teams
	list/tdome1 = list()
	list/tdome2 = list()

	//Where prison station guards can be warped to
	list/prisonsecuritywarp = list()

	//List of players who have already been warped to the prison station
	list/prisonwarped = list()

	//All the traitors in the round
	list/killer = list()

	//Objectives for the traitors
	list/traitobj = list(  )


	// **********************************
	//	Station Automation
	// **********************************

	//Cellular controller - the main loop for the code that manages airflow, machinery, players, etc
	datum/control/cellular/cellcontrol = null

	//Ticker for timed events such as the shuttle, etc
	datum/control/gameticker/ticker = null

	//All the Pipelines in the world
	list/plines = list()

	//Gas flows, seems to be used by the cryo system?
	list/gasflowlist = list()

	//All the machines in play
	list/machines = list()

	//All powernets in the world
	list/powernets = null

	//1 if Powernets will be manually rebuilt after an event (e.g. bomb blast)
	defer_powernet_rebuild = 0

	//1 if the Powernets are still being rebuilt
	powernets_building = 1

	//The Sun
	datum/sun/sun = null

	//A list of all the elevators in the world
	list/datum/elevator/elevators = list( )


	// **********************************
	//	Debug
	// **********************************

	Debug = 0
	Debug2 = 0
	DebugN = 0

	//Seems to be some way of accessing various lists and such.  See _debug.dm
	datum/debug/debugobj


	//No idea, seems to be a half-implemented-then-dropped thing
	datum/moduletypes/mods = new()


	// **********************************
	//	Admin Secrets
	// **********************************

	//It's a goddamn party!
	//But there's no way to start it.
	partysecret = 0

	//An admin-spawned wave of meteors is currently assaulting the station
	//and helping everyone experience the sheer joy of explosive decompression
	wavesecret = 0

	//Crackdown on admin abuse
	//Basically means none of the secrets will work
	crackdown = 1


	// **********************************
	//	The Shuttles
	// **********************************

	//NOTE: Shuttle destination variables are in the Multiple Z-Level Support section

	//How many points are available with which to buy stuff on the supply shuttle
	supply_shuttle_points = 50

	//Whether the emergency shuttle is coming towards the station (if not, and the timer is not 10 minutes, then
	//it's heading back to centcom)
	shuttlecomming = 0


	// **********************************
	//	Networking Support
	// **********************************

	//Network address generation info
	list/usedtypes = list()
	list/usedids = list()
	list/usednetids = list()

	//True if computernet rebuild will be called manually after an event
	defer_computernet_rebuild = 0

	//Computernets in the world.
	list/datum/computernet/computernets = null

	//All the passwords needed for specific network devices
	list/accesspasswords = list()

	//Routing table used for networking
	datum/rtable/routingtable = new /datum/rtable()


	// **********************************
	//	Multiple Z-Level Support
	// **********************************

	stationfloors = list( ) //What Z levels are considered to be "on the station"
	centcomfloors = list( ) //What Z levels are considered to be "on centcom"

	shuttle_z = 2	//Where the emergency (escape) shuttle is

	//Which Z-Levels the shuttles use
	centcom_supply_dock = 2
	centcom_emerg_dock = 2
	station_emerg_dock = 1
	station_supply_dock = 1
	station_prison_dock = 1
	station_syndicate_dock = 1
	prison_shuttle_dock = 2
	syndicate_shuttle_dock = 6
	shuttle_en_route_level = 3 //This may or may not be split up in future.

	//What Z-Level engine components get ejectec to
	engine_eject_z_target = 3


	// **********************************
	//	Message of The Day vars
	// **********************************

	join_motd = "Welcome to SS13!"
	auth_motd = "Welcome to SS13!, admin!"
	no_auth_motd = null


	// **********************************
	//	Airlocks
	// **********************************

	//airlockWireColorToIndex takes a number representing the wire color, e.g. the orange wire is always 1, the dark red wire is always 2, etc. It returns the index for whatever that wire does.
	//airlockIndexToWireColor does the opposite thing - it takes the index for what the wire does, for example AIRLOCK_WIRE_IDSCAN is 1, AIRLOCK_WIRE_POWER1 is 2, etc. It returns the wire color number.
	//airlockWireColorToFlag takes the wire color number and returns the flag for it (1, 2, 4, 8, 16, etc)
	list/airlockWireColorToFlag = RandomAirlockWires()
	list/airlockIndexToFlag
	list/airlockIndexToWireColor
	list/airlockWireColorToIndex
	list/APCWireColorToFlag = RandomAPCWires()
	list/APCIndexToFlag
	list/APCIndexToWireColor
	list/APCWireColorToIndex


world
	mob = /mob/human
	turf = /turf/space
	area = /area
	view = "15x15"

client/script = {"<style>
.ooc_title, .ooc_text
{
	font-weight: bold;
	color: #002eb8;
}
</style>"}
