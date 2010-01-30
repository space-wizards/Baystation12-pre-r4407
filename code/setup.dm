#define CELLSTANDARD 3600000.0		// gas capacity of cell at STP

#define O2STANDARD 756000.0			// O2 standard value (21%)
#define N2STANDARD 2844000.0		// N2 standard value (79%)

#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC

#define FIREOFFSET 505				//bias for starting firelevel
#define FIREQUOT 15000				//divisor to get target temp from firelevel
#define FIRERATE 5					//divisor of temp difference rate of change

#define NORMPIPERATE 400				//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process


//FLAGS BITMASK
#define ONBACK 1			// can be put in back slot
#define TABLEPASS 2			// can pass by a table or rack
#define HALFMASK 4			// mask only gets 1/2 of air supply from internals

#define HEADSPACE 4			// head wear protects against space

#define MASKINTERNALS 8		// mask allows internals
#define SUITSPACE 8			// suit protects against space

#define USEDELAY 16			// 1 second extra delay on use
#define NOSHIELD 32			// weapon not affected by shield
// 64 is an unused flag, because everything's drivable by a mass driver now
// Don't reuse it until the flags are all cleaned up (using the #defined things rather than magic numbers)
// because some things probably still have flag 64 set
#define ONBELT 128			// can be put in belt slot
#define FPRINT 256			// takes a fingerprint
#define WINDOW 512			// window or window/door

#define GLASSESCOVERSEYES 1024
#define MASKCOVERSEYES 1024		// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES 1024		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH 2048		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH 2048

// channel numbers for power

#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 1
#define NOPOWER 2
#define POWEROFF 4		// tbd
#define MAINT 8			// under maintaince

#define ENGINE_EJECT_Z 3

#define EXCHANGE_SPEED 0.5 // speed at which two tiles near an equal pressure. 1 means that their pressure is equal after one tick.
#define VACUUM_SPEED 3 // how fast air is sucked from a tile if there's a vacuum. air is divided by this number on each tick.
#define GAS_PRECISION 1000 // to what number gas amounts should be rounded
#define TEMPERATURE_PRECISION 5 // to what number temperature should be rounded

var/const
	GAS_O2 = 1 << 0
	GAS_N2 = 1 << 1
	GAS_PL = 1 << 2
	GAS_CO2 = 1 << 3
	GAS_N2O = 1 << 4
