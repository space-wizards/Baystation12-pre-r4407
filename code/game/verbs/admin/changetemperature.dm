//debug proc for testing body temperature
/client/proc/modifytemperature(newtemp as num)
	set category = "Debug"
	set name = "mass edit temperature"
	set desc="edit temperature of all turfs in view"
	if(Debug2)
		for(var/turf/T in view())
			if(!T.updatecell)	continue
			T.temp = newtemp
			world.log_admin("[src.key] set [T]'s temp to [newtemp]")
		return
	else
		alert("Debugging is off")
		return




