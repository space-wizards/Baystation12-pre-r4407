/obj/machinery/floodlight
	name = "Emergency floodlight"
	icon = 'floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/weapon/cell/cell
	var/use = 1
	var/unlocked = 0
	var/open = 0
	var/chargepre
/obj/machinery/floodlight/process()
	while(on)
		sleep(10)
		if(!cell)
			icon_state = "floodo00"
			sd_SetLuminosity(0)
			return
		cell.charge -= use
		src.chargepre = cell.charge / cell.maxcharge
		if(cell.charge <= 0)
			icon_state = "floodo00"
			sd_SetLuminosity(0)
			return
/obj/machinery/floodlight/attack_hand()
	if(unlocked && open)
		if(cell)
			var/obj/item/weapon/cell/whoop = new(src)
			whoop.loc = src.loc
			whoop.charge = cell.charge
			cell = null
			overlays = null
			overlays += "floodo"
			return
	if(on)
		on = 0
		usr << "You turned off the light"
		icon_state = "flood00"
		sd_SetLuminosity(0)
		return
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		usr << "You turned the light on"
		icon_state = "flood01"
		sd_SetLuminosity(10)
		process()
		return
/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if(unlocked)
			unlocked = 0
			usr << "you screw the battery panel in place."
		else
			unlocked = 1
			usr << "You uncrew the battery panel."
	if (istype(W, /obj/item/weapon/crowbar))
		if(open)
			open = 0
			overlays = null
			usr << "You crowbar the battery panel in place."
			overlays = null
		else
			if(unlocked)
				open = 1
				usr << " You remove the battery panel."
				if(cell)
					overlays += "floodob"
				else
					overlays += "floodo"
	if (istype(W, /obj/item/weapon/cell))
		if(open && unlocked)
			if(!cell)
				src.cell = new/obj/item/weapon/cell(src)
				cell.maxcharge = W:maxcharge
				cell.charge = W:charge
				if(cell)
					overlays += "floodob"
				del W
/obj/machinery/floodlight/New()
	src.cell = new/obj/item/weapon/cell(src)
	cell.maxcharge = 1000
	cell.charge = 1000

