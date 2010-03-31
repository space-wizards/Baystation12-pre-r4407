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

area/hallway/north
	name = "North Hallway"
	icon_state = "nhallway"

area/hallway/south
	name = "South Hallway"
	icon_state = "shallway"

area/hallway/west
	name = "West Hallway"
	icon_state = "whallway"

/area/hallway/southwest
	name = "Southwest Hallway"
	icon_state = "shallway" //TODO make icon

// MedBay and related
area/medical/medbay
	name = "Medical Bay"
	icon_state = "medical"

area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"

area/medical/autopsy
	name = "Autopsy Room"
	icon_state = "morgue"

area/medical/waiting
	name = "Medical Bay Waiting Room"
	icon_state = "medical"

area/medical/office
	name = "Medical Bay Office"
	icon_state = "medical"

area/medical/patientA
	name = "In-Patient Room A"
	icon_state = "medical"

area/medical/patientB
	name = "In-Patient Room B"
	icon_state = "medical"

area/medical/patientC // For the crazies
	name = "Unstable Patient Room"
	icon_state = "medical"

area/storage/medstorage
	name = "Medical Storage"
	icon_state = "medstorage"

// Research labs
area/research/medical // Chemical and Genetic Research - usually considered one area
	name = "Medical Research Labs"
	icon_state = "research"

area/research/toxins
	name = "Plasma Research Lab"
	icon_state = "toxlab"

area/research/toxins/external
	name = "External Explosives Test Range"
	icon_state = "toxlab"
	requires_power = 0

// Security and related
area/security/security
	name = "Security Headquarters"
	icon_state = "security"

area/security/brig
	name = "Brig"
	icon_state = "brig"

area/security/checkpoint
	name = "Arrival Checkpoint"
	icon_state = "security"

area/security/nstation
	name = "North Security Station"
	icon_state = "security"

area/security/holding
	name = "North Security Station Holding Cells"
	icon_state = "brig"

area/security/sstation
	name = "South Security Station"
	icon_state = "security"

area/storage/secstorage
	name = "Security Storage"
	icon_state = "securitystorage"

area/security/forensics
	name = "Forensics Lab"
	icon_state = "security"

// administrative areas
area/administrative/bridge
	name = "Bridge"
	icon_state = "bridge"

area/administrative/court/courtroom
	name = "Courtroom"
	icon_state = "bridge"

area/administrative/court/counsel
	name = "Consultation Room"
	icon_state = "bridge"

// Crew Quarters
area/crewquarters
	name = "Crew Quarters"
	icon_state = "crew_quarters"

area/headquarters/captain
	name = "Captain's Quarters"
	icon_state = "crew_quarters"

area/headquarters/hop // Near Arrival Checkpoint
	name = "Head of Personnel's Quarters"
	icon_state = "crew_quarters"

area/headquarters/hos // Above Courtroom
	name = "Head of Security's Quarters"
	icon_state = "crew_quarters"

area/headquarters/hor // In Medical Research
	name = "Head of Research's Quarters"
	icon_state = "crew_quarters"

area/headquarters/hom // Above Atmospherics
	name = "Head of Maintenance's Quarters"
	icon_state = "crew_quarters"

// Crew Facilities
area/facilities/bar
	name = "Lounge"
	icon_state = "crew_quarters"

area/facilities/observation
	name = "Observation Deck"
	icon_state = "crew_quarters"

area/facilities/meeting
	name = "Meeting Room"
	icon_state = "bridge"

//Quartermaster's Office
area/supply/office
	name = "Supplies Office"
	icon_state = "supplies"

area/supply/warehouse
	name = "Supply Warehouse"
	icon_state = "supplies"

area/supply/dock
	name = "Supply Shuttle Dock"
	icon_state = "supplies"

// Chapel
area/chapel/chapel
	name = "Chapel"
	icon_state = "chapel"

area/chapel/office
	name = "Chapel Office"
	icon_state = "chapel"

area/chapel/coffin
	name = "Coffin Storage Area"
	icon_state = "chapel"

// Station Maintenance
area/maintenance/hall
	name = "Maintenance Hallway"
	icon_state = "green"

area/maintenance/atmos
	name = "Atmospherics"
	icon_state = ""

area/maintenance/janitor
	name = "Custodial Closet"
	icon_state = "green"

area/storage/toolstorage
	name = "Tool Storage"
	icon_state = "toolstorage"

area/storage/elecstorage
	name = "Electrical Storage"
	icon_state = "elecstorage"

area/storage/northspare
	name = "Spare Storage"
	icon_state = "toolstorage"

area/storage/southspare
	name = "Spare Storage"
	icon_state = "toolstorage"

// Maintenance corridors
area/maintenance/corridor/necorridor
	name = "Northeast Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/nwcorridor
	name = "Northwest Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/secorridor
	name = "Southeast Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/swcorridor
	name = "Southeast Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/eastcorridor
	name = "East Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/westcorridor
	name = "West Maintenance Corridor"
	icon_state = "green"

area/maintenance/corridor/centercorridor
	name = "Central Maintenance Corridor"
	icon_state = "green"

// Engine
area/engine/enginehall
	name = "Engine Hallway"
	icon_state = "engine"

area/engine/SMES
	name = "Engine SMES Room"
	icon_state = "engine"

area/engine/equipment
	name = "Engine Equipment Room"
	icon_state = "engine"

area/engine/canstorage
	name = "Engine Canister Storage Room"
	icon_state = "engine"

area/engine/monitoring
	name = "Engine Monitoring Room"
	icon_state = "engine"

area/engine/control
	name = "Engine Control Room"
	icon_state = "engine"

area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"

area/engine/combustion
	name = "Engine Combustion"
	icon_state = "engine"

area/engine/cooling
	name = "Engine Cooling"
	icon_state = "engine"

// Fire Station
area/rescue/firestation
	name = "Fire Station"
	icon_state = "fire_station"

// Solar Panels
area/solar/east
	name = "East Solar Panels"
	icon_state = "yellow"
	lightswitch = 0

area/solar/west
	name = "West Solar Panels"
	icon_state = "yellow"
	lightswitch = 0

// Prison Station
/area/prison/arrival
	name = "Prison Arrival Corridor"
	icon_state = "green"
	requires_power = 0

/area/prison/security/checkpoint
	name = "Prison Checkpoint"
	icon_state = "security"

/area/prison/security/security
	name = "Prison Security"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Barracks"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/foyer
	name = "Prison Foyer"
	icon_state = "yellow"

/area/prison/morgue // Unused
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Medical Research"
	icon_state = "research"

/area/prison/medical
	name = "Prison Medical Bay"
	icon_state = "medical"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/cell_block
	name = "Prison Cell Block"
	icon_state = "brig"

// CentComm
/area/centcomm
	name = "Centcomm"
	icon_state = "purple"
	requires_power = 0
	music = "music/ending.ogg"

/area/centcomm/resupply
	name = "Resupply Hangar"
	icon_state = "purple"
	requires_power = 0

// Misc.
area/tele
	name = "Teleporter Room"
	icon_state = "teleporter"

area/prototype
	name = "Prototype Engine"
	icon_state = "engine"

//
//Unmodified areas
//

// AI-monitored areas
/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "evastorage"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

// Turret-protected areas
/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai"
/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsolar
	name = "AI Sat Solar"
	icon_state = "south"

/area/turret_protected/AIsatext
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/maze/turret
	name = "Space"
	icon_state = "yellow"

/area/turret_protected/maze/turret2
	name = "Space"
	icon_state = "yellow"

// Auto-protected areas (?)
/area/auto_protected/north
	name = "Northern Space Zone"
	icon_state = "dk_yellow"

// Thunderdome
/area/tdome
	name = "Thunderdome"
	icon_state = "medical"

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

/area/execution
	name = "Execution Chamber"
	icon_state = "yellow"