var/supply_shuttle_z = 2

/proc/call_supply_shuttle(var/mob/user)
	if (!( ticker ))
		return

	if(supply_shuttle_z == centcom_supply_dock)	//This is the laziest proc ever
		user << "The supply shuttle has been called"
		var/area/A = locate(/area/shuttle_supply)
		for(var/area/B in A.superarea.areas)
			for(var/mob/M in B)
				M.show_message("\red Launch sequence initiated!")
				spawn(0)	shake_camera(M, 10, 1)
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				var/lum = 0
				if(AM.luminosity)
					lum = AM.luminosity
					AM.sd_SetLuminosity(0)
				AM.z = shuttle_en_route_level
				AM.Move()
				if(lum)
					AM.sd_SetLuminosity(lum)
			for(var/turf/T as turf in B)
				T.buildlinks()
		supply_shuttle_z = shuttle_en_route_level
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				var/lum = 0
				if(AM.luminosity)
					lum = AM.luminosity
					AM.sd_SetLuminosity(0)
				AM.z = station_supply_dock
				AM.Move()
				if(lum)
					AM.sd_SetLuminosity(lum)
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at station!")
				spawn(0)	shake_camera(M, 2, 1)
		supply_shuttle_z = station_supply_dock
	else if (supply_shuttle_z == station_supply_dock)
		user << "The supply shuttle has been sent back to CentCom"
		var/area/A = locate(/area/shuttle_supply)
		for(var/area/B in A.superarea.areas)
			for(var/mob/M in B)
				M.show_message("\red Launch sequence initiated!")
				spawn(0)	shake_camera(M, 10, 1)
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				var/lum = 0
				if(AM.luminosity)
					lum = AM.luminosity
					AM.sd_SetLuminosity(0)
				AM.z = shuttle_en_route_level
				AM.Move()
				if(lum)
					AM.sd_SetLuminosity(lum)
			for(var/turf/T as turf in B)
				T.buildlinks()
		supply_shuttle_z = shuttle_en_route_level
		sleep(rand(600,1800))
		for(var/area/B in A.superarea.areas)
			for(var/atom/movable/AM as mob|obj in B)
				var/lum = 0
				if(AM.luminosity)
					lum = AM.luminosity
					AM.sd_SetLuminosity(0)
				AM.z = centcom_supply_dock
				AM.Move()
				if(lum)
					AM.sd_SetLuminosity(lum)
			for(var/turf/T as turf in B)
				T.buildlinks()
			for(var/mob/M in B)
				M.show_message("\red Supply shuttle has arrived at Centcom!")
				spawn(0)	shake_camera(M, 2, 1)
		supply_shuttle_z = centcom_supply_dock
	else
		user << "\red Supply shuttle in transit already"
	if(0)world << "send shuttle 5"
