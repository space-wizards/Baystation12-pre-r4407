#define CELLSTANDARD 3.6e6	// Gas capacity of turf/canister at 100% normal atmospheric pressure
#define O2STANDARD 7.56e5	// O2 standard value (21%)
#define N2STANDARD 2.844e6	// N2 standard value (79%)

#define T0C 273.15			// 0degC
#define T20C 293.15			// 20degC

#define NORMPIPERATE 400	// Pipe-insulation rate divisor
#define HEATPIPERATE 8		// Heat-exch pipe insulation

#define UP 16				// Up direction, equivalent to Z-1 (Z levels are backwards in this codebase)
#define DOWN 32				// Down direction, equivalent to Z+1 (Z levels are backwards in this codebase)

#define ONBACK 1			// Can be put in backpack slot
#define TABLEPASS 2			// Can pass by a table or rack
#define HALFMASK 4			// Mask only gets 1/2 of air supply from internals
#define DEADLY 4			// Super-powerful weapon (???)
#define HEADSPACE 4			// Head wear protects against space

#define MASKINTERNALS 8		// Mask allows internals
#define SUITSPACE 8			// Suit protects against space

#define USEDELAY 16			// 1 second extra delay on use
#define NOSHIELD 32			// Weapon not affected by shield

#define ONBELT 128			// Can be put in belt slot
#define FPRINT 256			// Takes a fingerprint
#define WINDOW 512			// Window or window/door

#define GLASSESCOVERSEYES 1024
#define MASKCOVERSEYES 1024		// Get rid of some of the other retardation in these flags
#define HEADCOVERSEYES 1024		// Feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH 2048	// On other items, these are just for mask/head
#define HEADCOVERSMOUTH 2048

#define PLASMAGUARD 4096 //Guards against plasma getting into clothes and other porous items.
						 //When used for canisters/tanks, an anti-corrosion liner has been applied.

// channel numbers for power

#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 1			// Busted and needs to be repaired/replaced
#define NOPOWER 2			// Has no power (NOT the same as simply turned off)
#define POWEROFF 4			// Controlled by the machines
#define MAINT 8				// If the machine is under maintenance.  Is it even actually used?

#define EXCHANGE_SPEED 0.5 // Speed at which two tiles near an equal pressure. 1 means that their pressure is equal after one tick.
#define VACUUM_SPEED 3 // How fast air is sucked from a tile if there's a vacuum. air is divided by this number on each tick.
#define GAS_PRECISION 1000 // To what number gas amounts should be rounded
#define TEMPERATURE_PRECISION 5 // To what number temperature should be rounded

//These are symbolic, not literal, for use with helperprocs.dm's getZlevel()
#define Z_STATION		1
#define Z_SPACE			2
#define Z_CENTCOM		3
#define Z_ENGINE_EJECT	4

//Special Disabilities (M.sdisabililties ...)
#define BLIND 1
#define MUTE 2
#define DEAF 4

//Standard Disabilities (M.disabililties ...)
#define BADVISION 1	//I could just use the same-value defs above, but it's obfuscate the code.  This makes it easier to understand,
#define HEADACHEY 2	//So I'll use it instead.
#define COUGHY 4
#define TWITCHY 8
#define NERVOUS 16

#define FIRE_DAMAGE_MODIFIER  0.0215 //Higher values result in more external fire damage to the skin (default 0.0215)
#define AIR_DAMAGE_MODIFIER  2.025 //More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
#define INFINITY  1e31 //closer then enough

//Don't set this very much higher then 1024 unless you like inviting people in to DoS your server with message spam
#define MAX_MESSAGE_LEN 1024

#define SHUTTLE_TIME_IN_STATION 1800
#define SHUTTLE_TIME_TO_ARRIVE 6000

//Why are these consts instead of defines?
var/const
	GAS_O2 = 1 << 0
	GAS_N2 = 1 << 1
	GAS_PL = 1 << 2
	GAS_CO2 = 1 << 3
	GAS_N2O = 1 << 4
