/obj/item/weapon/gun/energy/proc/update_icon()
	if (src.whoseblood)
		src.blood = null
		src.add_blood(whoseblood)
	return
