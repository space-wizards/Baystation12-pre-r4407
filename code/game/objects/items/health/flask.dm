/obj/item/weapon/flasks/examine()
	set src in oview(1)
	usr << text("The flask is []% full", (src.oxygen + src.plasma + src.coolant) * 100 / 500)
	usr << "The flask can ONLY store liquids."
	return