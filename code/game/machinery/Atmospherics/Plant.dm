obj/machinery/atmosplant
	name = "Plant"
	desc = "Converts CO2 to O2 using plants."
	var/water = 500


obj/machinery/atmosplant/process()
	var/turf/T = src.loc

	var/co2 = T.co2()

	var/convert = min(co2, 500)

	var/obj/substance/gas/flowing = new()

	flowing.co2 = convert



