// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/weapon/cell/New()
	..()

	charge = charge * maxcharge/100.0		// map obj has charge as percentage, convert to real value here

	spawn(5)
		updateicon()


/obj/item/weapon/cell/proc/updateicon()
	if(buildstate == 0)
		if(maxcharge <= 2500)
			icon_state = "cell"
		else
			icon_state = "hpcell"

		overlays = null

		if(charge < 0.01)
			return
		else if(charge/maxcharge >=0.995)
			overlays += image('power.dmi', "cell-o2")
		else
			overlays += image('power.dmi', "cell-o1")
	else if(buildstate == 1)
		overlays = null
		icon_state = "cell_drained"
	else if(buildstate == 2)
		overlays = null
		icon_state = "cell_plasma"
	else if(buildstate == 3)
		icon_state = "cell_plasma_lit"
	else if(buildstate == 4)
		icon_state = "cell_plasma_fin"

/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/weapon/cell/examine()
	set src in view(1)
	if(usr && !usr.stat)
		if(maxcharge <= 2500)
			usr << "[desc]\nThe manufacturer's label states this cell has a power rating of [maxcharge], and that you should not swallow it.\nThe charge meter reads [round(src.percent() )]%."
		else
			usr << "This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of [maxcharge]!!!\nThe charge meter reads [round(src.percent() )]%."

// common helper procs for all power machines
/obj/item/weapon/cell/attackby(obj/item/weapon/clothing/gloves/W, mob/user)
	if(charge < 5000)
		return
	else
		var/a = charge
		W.elecgen = 1
		W.uses = 1
		charge = a - 5000
		updateicon()
		user << "\red These gloves are now temporarily electrically charged!"

/obj/item/weapon/cell/attackby(obj/item/weapon/screwdriver/S, mob/user)
	if(buildstate == 0)
		user << "You drain the battery acid"
		buildstate = 1
		charge = 0


	if(buildstate == 3)
		user << "You seal the battery"
		buildstate = 4
		charge = 500000
		maxcharge = 500000

/obj/item/weapon/cell/attackby(obj/item/weapon/tank/plasmatank, mob/user)
	if(buildstate == 1)
		user << "You fill the battery with plasma"
		buildstate = 2
/obj/item/weapon/cell/attackby(obj/item/weapon/weldingtool, mob/user)
	if(buildstate == 2)
		user << "You ignite the plasma in the cell"
		buildstate = 3

