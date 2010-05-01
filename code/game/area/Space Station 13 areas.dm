/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/

/*
This has been cleaned up from prior versions.  A few were kept, which could either not be replaced
due to being required, or were not understood well enough to rist removal  It was also categorized
for easier modification.
	- Trorbes 27/12/09
*/

// Primary Hallways
area/hallway/east
	name = "East Hallway"
	icon_state = "ehallway"
	music = ""

area/hallway/north
	name = "North Hallway"
	icon_state = "nhallway"
	music = ""

area/hallway/south
	name = "South Hallway"
	icon_state = "shallway"
	music = ""

area/hallway/west
	name = "West Hallway"
	icon_state = "whallway"
	music = ""

/area/hallway/southwest
	name = "Southwest Hallway"
	icon_state = "shallway" //TODO make icon
	music = ""

// MedBay and related
area/medical/medbay
	name = "Medical Bay"
	icon_state = "medical"
	music = ""

area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	music = ""

area/medical/autopsy
	name = "Autopsy Room"
	icon_state = "morgue"
	music = ""

area/medical/waiting
	name = "Medical Bay Waiting Room"
	icon_state = "medical"
	music = ""

area/medical/office
	name = "Medical Bay Office"
	icon_state = "medical"
	music = ""

area/medical/patientA
	name = "In-Patient Room A"
	icon_state = "medical"
	music = ""

area/medical/patientB
	name = "In-Patient Room B"
	icon_state = "medical"
	music = ""

area/medical/patientC // For the crazies
	name = "Unstable Patient Room"
	icon_state = "medical"
	music = ""

area/storage/medstorage
	name = "Medical Storage"
	icon_state = "medstorage"
	music = ""

// Research labs
area/research/medical // Chemical and Genetic Research - usually considered one area
	name = "Medical Research Labs"
	icon_state = "research"
	music = ""

area/research/toxins
	name = "Plasma Research Lab"
	icon_state = "toxlab"
	music = ""

area/research/toxins/external
	name = "External Explosives Test Range"
	icon_state = "toxlab"
	requires_power = 0
	music = ""

// Security and related
area/security/security
	name = "Security Headquarters"
	icon_state = "security"
	music = ""

area/security/brig
	name = "Brig"
	icon_state = "brig"
	music = ""

area/security/checkpoint
	name = "Arrival Checkpoint"
	icon_state = "security"
	music = ""

area/security/nstation
	name = "North Security Station"
	icon_state = "security"
	music = ""

area/security/holding
	name = "North Security Station Holding Cells"
	icon_state = "brig"
	music = ""

area/security/sstation
	name = "South Security Station"
	icon_state = "security"
	music = ""

area/storage/secstorage
	name = "Security Storage"
	icon_state = "securitystorage"
	music = ""

area/security/forensics
	name = "Forensics Lab"
	icon_state = "security"
	music = ""

// administrative areas
area/administrative/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = 'music/bridge.ogg'

area/administrative/court/courtroom
	name = "Courtroom"
	icon_state = "bridge"
	music = ""

area/administrative/court/counsel
	name = "Consultation Room"
	icon_state = "bridge"
	music = ""

//Elevators
area/elevators
	icon_state = "yellow"
	sd_lighting = 0

area/elevators/centcom
	name = "Centcom Elevator"

//Airlocks
area/airlocks
	icon_state = "yellow"

area/airlocks/northwest
	music = ""
	name = "Northwest Airlock"

area/airlocks/west
	music = ""
	name = "West Airlock"

area/airlocks/northeast
	music = ""
	name = "Northeast Airlock"

area/airlocks/east
	music = ""
	name = "East Airlock"

area/airlocks/eva
	music = ""
	name = "EVA Airlock"

// Crew Quarters
area/crewquarters
	name = "Crew Quarters"
	icon_state = "crew_quarters"
	music = ""

area/headquarters/captain
	name = "Captain's Quarters"
	icon_state = "crew_quarters"
	music = ""

area/headquarters/hop // Near Arrival Checkpoint
	name = "Head of Personnel's Quarters"
	icon_state = "crew_quarters"
	music = ""

area/headquarters/hos // Above Courtroom
	name = "Head of Security's Quarters"
	icon_state = "crew_quarters"
	music = ""

area/headquarters/hor // In Medical Research
	name = "Head of Research's Quarters"
	icon_state = "crew_quarters"
	music = ""

area/headquarters/hom // Above Atmospherics
	name = "Head of Maintenance's Quarters"
	icon_state = "crew_quarters"
	music = ""

// Crew Facilities
area/facilities/bar
	name = "Lounge"
	icon_state = "crew_quarters"
	music = ""

area/facilities/observation
	name = "Observation Deck"
	icon_state = "crew_quarters"
	music = ""

area/facilities/meeting
	name = "Meeting Room"
	icon_state = "bridge"
	music = ""

//Quartermaster's Office
area/supply/office
	name = "Supplies Office"
	icon_state = "supplies"
	music = ""

area/supply/warehouse
	name = "Supply Warehouse"
	icon_state = "supplies"
	music = ""

area/supply/dock
	name = "Supply Shuttle Dock"
	icon_state = "supplies"
	music = ""

// Chapel
area/chapel/chapel
	name = "Chapel"
	icon_state = "chapel"
	music = ""

area/chapel/office
	name = "Chapel Office"
	icon_state = "chapel"
	music = ""

area/chapel/coffin
	name = "Coffin Storage Area"
	icon_state = "chapel"
	music = ""

// Station Maintenance
area/maintenance/hall
	name = "Maintenance Hallway"
	icon_state = "green"
	music = ""

area/maintenance/network
	name = "Network Centre"
	icon_state = "network"
	music = ""

area/maintenance/atmos
	name = "Atmospherics"
	icon_state = "atmoss"
	music = "music/atmos.wav"

area/maintenance/atmos/mixing
	name = "Atmospherics Mixing Chamber"
	icon_state = "atmoss"
	music = "music/atmos.wav"

area/maintenance/atmos/mixingroom
	name = "Atmospherics Mixing room"
	icon_state = "atmoss"
	music = "music/atmos.wav"

area/maintenance/atmos/canister
	name = "Atmospherics Canister Storage"
	icon_state = "atmoss"
	music = "music/atmos.wav"

area/maintenance/atmostanks/oxygen
	name = "Oxygen Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/plasma
	name = "Plasma Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/carbondioxide
	name = "CO2 Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/anesthetic
	name = "N2O Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/nitrogen
	name = "N2 Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/other
	name = "Waste Tank"
	icon_state = "atmoss"

area/maintenance/atmostanks/burn
	name = "Burnoff Chamber"
	icon_state = "atmoss"

area/maintenance/janitor
	name = "Custodial Closet"
	icon_state = "green"
	music = ""

area/storage/toolstorage
	name = "Tool Storage"
	icon_state = "toolstorage"
	music = ""

area/storage/elecstorage
	name = "Electrical Storage"
	icon_state = "elecstorage"
	music = ""

area/storage/northspare
	name = "Spare Storage"
	icon_state = "toolstorage"
	music = ""

area/storage/emergency
	name = "Emergency Storage"
	icon_state = "toolstorage"
	music = ""

area/storage/network
	name = "Network Storage"
	icon_state = "network"
	music = ""

area/storage/southspare
	name = "Spare Storage"
	icon_state = "toolstorage"
	music = ""

// Maintenance corridors
area/maintenance/corridor/necorridor
	name = "Northeast Maintenance Corridor"
	icon_state = "green"
	music = ""

area/maintenance/corridor/nwcorridor
	name = "Northwest Maintenance Corridor"
	icon_state = "green"
	music = ""

area/maintenance/corridor/secorridor
	name = "Southeast Maintenance Corridor"
	icon_state = "green"
	music = ""

area/maintenance/corridor/swcorridor
	name = "Southeast Maintenance Corridor"
	icon_state = "green"
	music = ""

area/maintenance/corridor/eastcorridor
	name = "East Maintenance Corridor"
	icon_state = "green"
	music = ""

area/maintenance/corridor/westcorridor
	name = "West Maintenance Corridor"
	music = ""
	icon_state = "green"

area/maintenance/corridor/northconnector
	name = "North Understation Maintenance Corridor"
	music = ""
	icon_state = "green"

area/maintenance/corridor/westconnector
	name = "West Understation Maintenance Corridor"
	music = ""
	icon_state = "green"

area/maintenance/corridor/centercorridor
	name = "Central Maintenance Corridor"
	icon_state = "green"
	music = ""

area/escape/pods1
	name = "Escape Pod Bay"
	icon_state = "escape"
	music = ""

area/escape/pods2
	name = "Escape Pod Bay"
	icon_state = "escape"
	music = ""

// Engine
area/engine/enginehall
	name = "Engine Hallway"
	icon_state = "engine"
	music = ""

area/engine/SMES
	name = "Engine SMES Room"
	icon_state = "engine"
	music = "music/smesroom.wav"

area/engine/equipment
	name = "Engine Equipment Room"
	icon_state = "engine"
	music = ""

area/engine/canstorage
	name = "Engine Canister Storage Room"
	icon_state = "engine"
	music = ""

area/engine/monitoring
	name = "Engine Monitoring Room"
	icon_state = "engine"
	music = ""

area/engine/control
	name = "Engine Control Room"
	icon_state = "engine"
	music = ""

area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"
	music = ""

area/engine/combustion
	name = "Engine Combustion"
	icon_state = "engine"
	music = ""

area/engine/cooling
	name = "Engine Cooling"
	icon_state = "engine"
	music = ""

// Fire Station
area/rescue/firestation
	name = "Fire Station"
	icon_state = "fire_station"
	music = ""

// Solar Panels
area/solar
	icon_state = "yellow"
	lightswitch = 0
	music = ""

area/solar/east
	name = "East Solar Panels"

area/solar/west
	name = "West Solar Panels"

// Prison Station
/area/prison/arrival
	name = "Prison Arrival Corridor"
	icon_state = "green"
	requires_power = 0
	music = ""

/area/prison/security/checkpoint
	name = "Prison Checkpoint"
	icon_state = "security"
	music = ""

/area/prison/security/security
	name = "Prison Security"
	icon_state = "security"
	music = ""

/area/prison/crew_quarters
	name = "Prison Security Barracks"
	icon_state = "security"
	music = ""

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"
	music = ""

/area/prison/foyer
	name = "Prison Foyer"
	icon_state = "yellow"
	music = ""

/area/prison/morgue // Unused
	name = "Prison Morgue"
	icon_state = "morgue"
	music = ""

/area/prison/medical_research
	name = "Prison Medical Research"
	icon_state = "research"
	music = ""

/area/prison/medical
	name = "Prison Medical Bay"
	icon_state = "medical"
	music = ""

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0
	music = ""

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"
	music = ""

/area/prison/cell_block
	name = "Prison Cell Block"
	icon_state = "brig"
	music = ""

//Comm Center
/area/comcenter
	name = "Commmunications Control"
	icon_state = "purple"
	linkarea = "comdish"
	music = ""

/area/comdish
	name = "Communications Dish"
	icon_state = "purple"
	music = ""

// CentComm
/area/centcomm
	name = "Centcomm"
	icon_state = "purple"
	music = "music/ending.ogg"

/area/centcomm/medical
	name = "Centcomm Medical"
	icon_state = "purple"
	music = "music/ending.ogg"

/area/centcomm/bar
	name = "Bar"
	icon_state = "purple"
	music = "music/ending.ogg"

/area/centcomm/resupply
	name = "Resupply Hangar"
	music = "music/ending.ogg"

/area/centcomm/podbay1
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay2
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay3
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay4
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay5
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay6
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay7
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay8
	name = "Pod Bay"
	music = "music/ending.ogg"

/area/centcomm/podbay9
	name = "Pod Bay"
	music = "music/ending.ogg"

// Misc.
area/tele
	name = "Teleporter Room"
	icon_state = "teleporter"
	music = ""

area/prototype
	name = "Prototype Engine"
	icon_state = "engine"
	music = ""

//
//Unmodified areas
//

// AI-monitored areas
/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "evastorage"
	music = ""

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"
	music = ""

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"
	music = ""

// Turret-protected areas
/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai"
	music = ""

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai"
	music = ""

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai"
	music = ""

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"
	music = ""

/area/turret_protected/AIsolar
	name = "AI Sat Solar"
	icon_state = "south"
	music = ""

/area/turret_protected/AIsatext
	name = "AI Sat Ext"
	icon_state = "storage"
	music = ""

/area/turret_protected/maze/turret
	name = "Space"
	icon_state = "yellow"
	music = ""

/area/turret_protected/maze/turret2
	name = "Space"
	icon_state = "yellow"
	music = ""

// Auto-protected areas (?)
/area/auto_protected/north
	name = "Northern Space Zone"
	icon_state = "dk_yellow"
	music = ""

// Thunderdome
/area/tdome
	name = "Thunderdome"
	icon_state = "medical"
	music = "music/THUNDERDOME.ogg"

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomea
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

// Syndicate
/area/syndicate_ship
	name = "Mysterious Vessel"
	icon_state = "yellow"
	requires_power = 0
	music = ""

/area/execution
	name = "Execution Chamber"
	icon_state = "yellow"
	music = ""