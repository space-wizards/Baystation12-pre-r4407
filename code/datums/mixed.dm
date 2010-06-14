/datum/air_tunnel
	//name = "air tunnel"
	var/operating = 0
	var/siphon_status = 0
	var/air_stat = 0
	var/list/connectors = list()
/datum/
	var/global/oxygenburn = 250000
/datum/air_tunnel/air_tunnel1
	//name = "air tunnel1"

/datum/control
	//name = "control"
	var/processing = 1.0

/datum/control/cellular
	//name = "cellular"
	var/checkfire = 0.0
	var/time = 0

/datum/control/gameticker
	//name = "gameticker"
	var/timeleft = null
	var/timing = 0.0
	var/mob/human/killer = null
	var/mob/human/killer2 = null
	var/mob/human/killer3 = null
	var/mob/human/target = null
	var/mob/human/target2 = null
	var/mob/human/target3 = null
	var/mob/human/target4 = null
	var/mob/human/target5 = null
	var/theft_obj = null
	var/sab_target = null
	var/objective = null
	var/stage = null
	var/shuttle_location = null
	var/AItime
	var/AIwin = 18000

	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0
	var/list/mob/revs = list()
	var/list/mob/targets = list()

/datum/control/poll
	//name = "poll"
	var/question = null

	var/list/answers = list(  )

/datum/data
	var/name = "data"
	var/size = 1.0
	//name = null
/datum/data/function
	name = "function"
	size = 2.0
/datum/data/function/data_control
	name = "data control"
/datum/data/function/id_changer
	name = "id changer"
/datum/data/record
	name = "record"
	size = 5.0

	var/list/fields = list(  )

/datum/data/text
	name = "text"
	var/data = null
/datum/engine_eject
	//name = "engine eject"
	var/status = 0.0
	var/resetting = null
	var/timeleft = 60.0

/datum/station_state
	var/floor = 0
	var/wall = 0
	var/r_wall = 0
	var/window = 0
	var/door = 0
	var/grille = 0
	var/mach = 0

/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all APCs & sources
	var/newload = 0
	var/load = 0
	var/newavail = 0
	var/avail = 0

	var/viewload = 0

	var/number = 0

	var/perapc = 0			// per-apc avilability

	var/netexcess = 0

/datum/debug
	var/list/debuglist