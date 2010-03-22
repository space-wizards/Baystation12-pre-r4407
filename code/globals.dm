var
	no_end = 0 // This is the default: 0 = always reboot, 1 = reboot only on force quit or no-players-alive quit, and vote quit, 2 = never reboot(except by force such as admin command or remote restart)
	crackdown = 1
	eventchance = 1
	event = 0
	hadevent = 0
	blobevent = 0
	canplaysound = 1
	savefile_ver = "3"
	SS13_version = "Official Bay12 Games Server, latest updates!"
	datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
	datum/control/cellular/cellcontrol = null
	datum/control/gameticker/ticker = null
	obj/datacore/data_core = null
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null
	going = 1.0
	master_mode = "random"//"extended"
	air_cycle = 5
	worldsetup = 0
	date = time2text(world.realtime,"DD-MM-YY")
	persistent_file = "data/mode.txt"
	medals_file = "data/medals.txt"
	log_file = "logs/[date]-log.txt"
	log_file_verbose = "logV.txt"
	nuke_code = null
	poll_controller = null
	datum/engine_eject/engine_eject_control = null
	host = null
	obj/hud/main_hud1 = null
	obj/hud/hud2/main_hud2 = null
	ooc_allowed = 1
	dna_ident = 1
	abandon_allowed = 1
	enter_allowed = 1
	shuttle_frozen = 0

	list/bombers = list(  )
	list/lastsignalers = list(	)	//keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
	list/admins = list(  )
	list/shuttles = list(  )
	list/reg_dna = list(  )
	list/traitobj = list(  )
//	Bans handled by Crispy Fullban in /admin/ban.dm now
//	list/banned = list(  )

	CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
	CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

	shuttle_z = 2	//default
	airtunnel_start = 68 // default
	airtunnel_stop = 68 // default
	airtunnel_bottom = 72 // default
	list/monkeystart = list()
	list/prisonwarp = list()	//prisoners go to these
	list/mazewarp = list()
	list/tdome1 = list()
	list/tdome2 = list()
	list/prisonsecuritywarp = list()	//prison security goes to these
	list/prisonwarped = list()	//list of players already warped
	list/blobstart = list()
	list/blobs = list()
	list/killer = list()
	list/cardinal = list( NORTH, SOUTH, EAST, WEST )


	datum/station_state/start_state = null
	datum/configuration/config = null
	datum/vote/vote = null
	datum/sun/sun = null

	list/plines = list()
	list/gasflowlist = list()
	list/machines = list()

	list/powernets = null

	defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event

	Debug = 0	// global debug switch
	Debug2 = 0

	datum/debug/debugobj

	datum/moduletypes/mods = new()

	partysecret = 0
	wavesecret = 0

	shuttlecomming = 0

	join_motd = "Welcome to SS13!"
	auth_motd = "Welcome to SS13!, admin!"
	no_auth_motd = null
	forceblob = 0

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

	const/FIRE_DAMAGE_MODIFIER = 0.0215 //Higher values result in more external fire damage to the skin (default 0.0215)
	const/AIR_DAMAGE_MODIFIER = 2.025 //More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
	const/INFINITY = 1e31 //closer then enough

	//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
	const/MAX_MESSAGE_LEN = 1024

	const/shuttle_time_in_station = 1800 // 3 minutes in the station
	const/shuttle_time_to_arrive = 6000 // 10 minutes to arrive
	/* Radio shit*/
	radio = 1
	longradio = 1
	list/humans_left_lol = ""
	list/zombies_left_lol = ""
	goal_killer = ""
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

var/list/permaban = dd_file2list("config/permaban.txt")