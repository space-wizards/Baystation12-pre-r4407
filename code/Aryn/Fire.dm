#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC

var/global/FIREOFFSET = 505				//bias for starting firelevel
var/global/FIREQUOT = 15000				//divisor to get target temp from firelevel
var/global/FIRERATE = 5					//divisor of temp difference rate of change

#define CELLSTANDARD 3600000.0

var/global/FIRE_SPREAD_DELAY = 3
//Changes the rate at which fire processes, leading to faster spread, faster temp increases, and faster extinguishing.

var/global/GAS_FLOW_DELAY = 10 //This value is the delay for gas.

turf/proc/temp_set(n)
	if(zone)
		zone.temp = abs(n)
		if(zone.speakmychild) world << "Temperature set to [abs(n)]"
var/fire_spread = 0
proc/FireTicker()
	var/fticks = 0
	while(1)
		sleep(1)
		fticks++
		if(!ticker) continue
		if(!(fticks % FIRE_SPREAD_DELAY))
		//sleep(FIRE_SPREAD_DELAY)
			//world << "Fire Spread!"
			for(var/turf/station/T)
				if(T.burn)
					T.icon_state = "burning"
					spawn T.Burn()
				else if(T.icon_state == "burning")
					T.unburn()

				if(T.firelevel > 100000) T.burn = 1
		//sleep(GAS_FLOW_DELAY)
		if(!(fticks % GAS_FLOW_DELAY))
			//world << "<b>Gas Flow!!</b>"
			for(var/turf/station/T)
				if(T.poison || T.sl_gas)
					spawn T.DistributeGas()
world/New()
	..()
	spawn(2) FireTicker()
turf
	//var/fire_level = 0
	var/fireicon = 0
	var/burn_level = 0
	proc/Burn()
		if(!zone) return
		if (oxygen() < 1000)
			burn = 0
			firelevel = 0
			return
		if(1)
			if (src.firelevel >= 100000.0)
				//src.overlays += 'Fire.dmi'
				//icon_state = "burning"
				if(luminosity != 4)
					sd_SetLuminosity(4)

				zone.gases["O2"] = max(zone.gases["O2"] - 5000, 0)
				src.poison = max(src.poison - 5000, 0)
				src.co2(5000)

				if(src.oxygen() == 0 || src.poison == 0)
					burn = 0 // make fires stop when they run out of oxygen or plasma
					firelevel = 0
					return
					//overlays -= 'Fire.dmi'
					//unburn()

				// heating from fire
				temp((firelevel/FIREQUOT+FIREOFFSET - temp()) / FIRERATE)
				if(zone.speakmychild)
					world << "Fire temperature: +[(firelevel/FIREQUOT+FIREOFFSET - temp) / FIRERATE]C"
					world << "Firelevel: [firelevel], temp: [temp()]"


				if (locate(/obj/effects/water, src))
					src.firelevel = 0
				for(var/atom/movable/A in src)
					A.burn(src.firelevel)
					//Foreach goto(522)
				for(var/turf/T in GetCardinals(src,3))
					if(Airtight(T,src)) continue
					T.firelevel = T.poison
					if(T.firelevel > 100000)
						T.burn = 1
			else
				src.firelevel = 0
				burn = 0
				//temp((T20C - temp) / FIRERATE)
				return
				//overlays -= 'Fire.dmi'
				//if (src.icon_state == "burning")
				//	unburn()
			if (burn)
				src.firelevel = src.oxygen + src.poison


		if ((locate(/obj/effects/water, src) || src.firelevel < 100000.0))
			src.firelevel = 0
			burn = 0
			//cool due to water
			temp((T20C - temp) / FIRERATE)
		oldfirelevel = firelevel