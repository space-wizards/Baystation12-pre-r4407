
obj/machinery/vendingmachine/water/attack_hand(mob/user as mob)
	if(!water)
		return
	water--
	var/obj/item/weapon/food/waterbottle/S = new()
	S.loc = src.loc
	S.y -= 1
/*	var/dat = {"<BR><A HREF='?src=\ref[src];getwater'>Space helmet(20)</A></BR>"}
	dat += "<A HREF='?src=\ref[user];mach_close=vendor'>Close</A> \]"
	usr << browse(dat,"window=vendor;;display=1;size=300x300;border=0;can_close=1;")*/

obj/machinery/vendingmachine/water/attack_ai(mob/user as mob)
	return
obj/machinery/vendingmachine/water/Topic(href,href_list[],hsrc)
	if(href == "getwater")
		water--
		var/obj/item/weapon/food/waterbottle/S = new()
		S.loc = src.loc
