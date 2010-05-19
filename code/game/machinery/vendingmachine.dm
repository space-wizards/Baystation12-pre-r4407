
/obj/machinery/vendingmachine/New()
	..()
	sd_SetLuminosity(3)

/obj/machinery/vendingmachine/power_change()
	var/oldp = (stat & NOPOWER ? 0 : 1)
	..()
	if ((stat & NOPOWER ? 0 : 1) != oldp)
		sd_SetLuminosity(stat & NOPOWER ? 0 : 3)

obj/machinery/vendingmachine/water/attack_hand(mob/user as mob)
	if(!water)
		user << "The vending machine is out of water"
		return
	water--
	user << "You get a bottle of water from the vending machine"
	var/obj/item/weapon/food/waterbottle/S = new()
	S.loc = src.loc

obj/machinery/vendingmachine/water/attack_ai(mob/user as mob)
	return

obj/machinery/vendingmachine/water/Topic(href,href_list[],hsrc)
	if(href == "getwater")
		water--
		var/obj/item/weapon/food/waterbottle/S = new()
		S.loc = src.loc
