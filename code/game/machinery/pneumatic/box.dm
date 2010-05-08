/obj/item/weapon/box
	level = 1
	anchored = 0
	name = "Package"
	desc = "A rigid box used for transfering items across the station"
	icon = 'pnu.dmi'
	icon_state = "box"

	var/obj/machinery/pnuexit/destination = null

	var/list/obj/machinery/pnutube/path[]

/obj/item/weapon/box/attack_self(mob/user as mob)
	var/list/obj/machinery/pnuexit/L = list()
	for(var/obj/machinery/pnuexit/P in world)
		L += P

	var/obj/machinery/pnuexit/Exit = input(user,"Select a destination to label on the box") as null|anything in L
	destination = Exit