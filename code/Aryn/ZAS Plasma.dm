turf/var/list/dist_links
turf/var
	has_plasma
	has_n2o
	dist_timer
turf/proc/DistributeGas()
	dist_timer = (dist_timer + 1) % 3
	if(!dist_timer)
		dist_links = GetCardinals(src)
		for(var/turf/T in dist_links)
			if(Airtight(T,src)) dist_links -= T
		dist_links += src
		var
			total_plasma
			total_n2o
		for(var/turf/T in dist_links)
			total_plasma += T.poison
			total_n2o += T.sl_gas
		for(var/turf/T in dist_links)
			T.poison = total_plasma / (dist_links.len)
			T.sl_gas = total_n2o / (dist_links.len)
			if(T.poison() > 100000)
				if(!T.has_plasma)
					T.overlays += plmaster
					T.has_plasma = 1
			else if(T.has_plasma)
				T.overlays -= plmaster
				T.has_plasma = 0
			if(T.sl_gas() > 101000)
				if(!T.has_n2o)
					T.overlays += slmaster
					T.has_n2o = 1
			else if(T.has_n2o)
				T.overlays -= slmaster
				T.has_n2o = 0
		if(zone)
			zone.gases["Plasma"] += poison * 0.001
			poison -= poison * 0.001
			zone.gases["N2O"] += sl_gas * 0.001
			sl_gas -= sl_gas * 0.001