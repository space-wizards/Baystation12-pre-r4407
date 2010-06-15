/obj/machinery/vendingmachine
	name = "Vending Machine"
	desc = "A vending machine"
	anchored = 1
	density = 1
	icon = 'food.dmi'
	var/list/names = list( )
	var/list/instock = list( )
	var/list/types = list( )

/obj/machinery/vendingmachine/New()
	..()
	sd_SetLuminosity(3)

/obj/machinery/vendingmachine/power_change()
	var/oldp = (stat & NOPOWER ? 0 : 1)
	..()
	if ((stat & NOPOWER ? 0 : 1) != oldp)
		sd_SetLuminosity(stat & NOPOWER ? 0 : 3)

/obj/machinery/vendingmachine/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vendingmachine/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vendingmachine/attack_hand(mob/user as mob)
	showpanel(user)

/obj/machinery/vendingmachine/proc/showpanel(mob/user as mob)
	var/dat = "<TT><b>[name]</b><hr>"

	for(var/i = 1, i <= names.len, i++)
		dat += "[names[i]] - <a href='?src=\ref[src];vend=[i]'>Vend</a><br>"

	dat += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	dat += "</TT>"

	user << browse(dat, "window=vender;size=325x500")
	usr.machine = src

obj/machinery/vendingmachine/Topic(href,href_list[],hsrc)
	if(href_list["close"])
		usr << browse(null, "window=vender")
		usr.machine = null
		return

	if(href_list["vend"])
		var/i = text2num(href_list["vend"])
		if (instock[i])
			instock[i]--
			usr << "\blue The machine dispenses a [names[i]]"
			Vend(types[i], usr)
		else
			usr << "\red The vending machine doesn't have another [names[i]]."

obj/machinery/vendingmachine/proc/Vend(var/type, mob/user as mob)
	if (istype(usr, /mob/ai))
		var/atom/S = new type(loc) //Lol, AIs can't pick up stuff from a vending machine!
		user << "The [S.name] falls to the floor"
	else if(user.hand)
		if (user.l_hand)
			var/atom/S = new type(loc) //They can't pick it up, so drop it on the floor
			user << "\red You can't pick up the [S.name] while holding something in your left hand"
		else
			var/atom/S = new type(user)
			S.layer = 52
			user.l_hand = S
			S.add_fingerprint(user)
	else
		if (user.r_hand)
			var/atom/S = new type(loc) //They can't pick it up, so drop it on the floor
			user << "\red You can't pick up the [S.name] while holding something in your right hand"
		else
			var/atom/S = new type(user)
			S.layer = 52
			user.r_hand = S
			S.add_fingerprint(user)
	return