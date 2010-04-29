#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC

#define FIREOFFSET 505				//bias for starting firelevel
#define FIREQUOT 15000				//divisor to get target temp from firelevel
#define FIRERATE 5					//divisor of temp difference rate of change

#define CELLSTANDARD 3600000.0

/*
Average 1 tank fire is 500C.
Multiple tanks can accelerate it to 1500+C at which point EVERYONE DIES! the end.
*/

turf/proc/temp_set(n)
	if(zone)
		zone.temp = n
var/fire_spread = 0
proc/FireTicker()
	while(1)
		sleep(5)
		for(var/turf/station/T)
			if(T.burn)
				T.icon_state = "burning"
				spawn T.Burn()
			else if(T.icon_state == "burning")
				T.unburn()

			if(T.firelevel > 100000) T.burn = 1

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
				temp((firelevel/FIREQUOT+FIREOFFSET - temp) / FIRERATE)


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
				temp((T20C - temp) / FIRERATE)
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