#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC

vs_control/var/FIREOFFSET = 505				//bias for starting firelevel
vs_control/var/FIREQUOT = 15000				//divisor to get target temp from firelevel
vs_control/var/FIRERATE = 5					//divisor of temp difference rate of change

#define CELLSTANDARD 3600000.0

vs_control/var/FIRE_SPREAD_DELAY = 3
//Changes the rate at which fire processes, leading to faster spread, faster temp increases, and faster extinguishing.
vs_control/var/GAS_FLOW_DELAY = 10 //This value is the delay for gas.

turf/proc/temp_set(n)
	if(zone)
		var/diff = abs(n) - zone.temp
		temp(diff)
		if(zone.speakmychild) world << "Temperature set to [zone.temp] ([n])"
var/fire_spread = 0
proc/FireTicker()
	var/fticks = 0
	spawn(5)
		for(var/turf/station/T)
			T.GetDistLinks()
	while(1)
		sleep(1)
		fticks++
		if(!ticker) continue
		if(!(fticks % vsc.FIRE_SPREAD_DELAY))
		//sleep(FIRE_SPREAD_DELAY)
			//world << "Fire Spread!"
			for(var/turf/station/T)
				if(T.burn && T.firelevel > 100000)
					spawn T.Burn()
				else if(T.fire_icon)
					T.overlays -= T.fire_icon
					del T.fire_icon

				if(T.firelevel > 100000) T.burn = 1
				else
					T.firelevel = 0
					T.burn = 0
		//sleep(GAS_FLOW_DELAY)
		if(!(fticks % vsc.GAS_FLOW_DELAY))
			//world << "<b>Gas Flow!!</b>"
			for(var/turf/station/T)
				if(T.poison || T.sl_gas)
					spawn T.DistributeGas()
				else
					if(T.has_plasma)
						T.has_plasma = 0
						T.overlays -= plmaster
					if(T.has_n2o)
						T.has_n2o = 0
						T.overlays -= slmaster
world/New()
	..()
	spawn(2) FireTicker()
turf
	//var/fire_level = 0
	var/image/fire_icon
	//var/burn_level = 0
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
				if(!fire_icon)
					fire_icon = new('Fire.dmi',icon_state="1")

				overlays -= fire_icon
				if(firelevel >= 500000)
					fire_icon.icon_state = "5"
				else if(firelevel >= 400000)
					fire_icon.icon_state = "4"
				else if(firelevel >= 300000)
					fire_icon.icon_state = "3"
				else if(firelevel >= 200000)
					fire_icon.icon_state = "2"
				else
					fire_icon.icon_state = "1"
				overlays += fire_icon


				if(luminosity != text2num(fire_icon.icon_state))
					sd_SetLuminosity(text2num(fire_icon.icon_state))

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
				temp((firelevel/vsc.FIREQUOT+vsc.FIREOFFSET - temp()) / vsc.FIRERATE)
				//if(zone.speakmychild)
					//world << "Fire: +5"
					//world << "Fire temperature: +[(firelevel/vsc.FIREQUOT+vsc.FIREOFFSET - temp) / vsc.FIRERATE]C"
					//world << "FIREQUOT: [vsc.FIREQUOT] FIREOFFSET: [vsc.FIREOFFSET] FIRERATE: [vsc.FIRERATE]"
					//world << "Firelevel: [firelevel], temp: [temp()]"


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
				//temp((T20C - temp) / vsc.FIRERATE)
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
			temp((T20C - temp) / vsc.FIRERATE)
		oldfirelevel = firelevel

	//verb/ShowTemp()
	//	set src in view()
	//	zone.speakmychild=1