/obj/item/weapon/gun/energy/proc/update_icon()
	var/ratio = src.charges / 10
	ratio = round(ratio, 0.25) * 100
	src.icon_state = text("gun[]", ratio)
	return
