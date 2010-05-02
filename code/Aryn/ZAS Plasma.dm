#define CLOTH_CONTAMINATION 1 //If this is on, plasma does damage by getting into cloth.
#define CANISTER_CORROSION 0 //If this is on, plasma must be stored in orange tanks and canisters, or it will corrode the tank.

turf/var/list/dist_links
turf/var
	has_plasma
	has_n2o
	dist_timer
turf/proc/DistributeGas()
	dist_links = GetCardinals(src,3)
	//or(var/turf/T in dist_links)
	//	if(Airtight(T,src)) dist_links -= T
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
	if(poison() > 100000)
		if(!has_plasma)
			overlays += plmaster
			has_plasma = 1
	else if(has_plasma)
		overlays -= plmaster
		has_plasma = 0
	if(sl_gas() > 101000)
		if(!has_n2o)
			overlays += slmaster
			has_n2o = 1
	else if(has_n2o)
		overlays -= slmaster
		has_n2o = 0
		//if(zone)
		//	zone.gases["Plasma"] += poison * 0
		//	poison -= poison * 0
		//	zone.gases["N2O"] += sl_gas * 0
		//	sl_gas -= sl_gas * 0

		//To make plasma and N2O become gases over time, use this.