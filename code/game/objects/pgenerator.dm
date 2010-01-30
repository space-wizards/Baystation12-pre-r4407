/obj/machinery/power/pgenerator
	name = "Portable generator"
	desc = "A portable thermoelectic microwave generator."
	density = 1
	anchored = 0

	var/plasma
	var/status
	var/amount = 100
	var/obj/item/weapon/tank/plasmatank/attached = null
	icon = "generator.dmi"
	icon_state = "off"