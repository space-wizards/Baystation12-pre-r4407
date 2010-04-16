

obj/machinery/atmosplant
	name = "atmosplant"
	desc = "Converts CO2 to O2 using plants."
	var/needwater = 0
	var/on = 0

obj/machinery/atmosplan/process()
	spawn while(on)
		if(needwater)
			spawn(10)
			process()
		if(

