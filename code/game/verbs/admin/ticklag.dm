/client/proc/ticklag(number as num)
	set category = "Debug"
	set name = "Ticklag"
	set desc = "Ticklag"
	if(Debug2)
		if(src.authenticated && src.holder)
			if(!src.mob)
				return
			if(src.holder.rank == "Coder")
				world.tick_lag = number
			else
				alert("Fuck off, no crashing dis server")
				return
	else
		alert("Debugging is disabled")
		return

