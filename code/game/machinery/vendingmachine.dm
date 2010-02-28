
/*obj/machinery/vendingmachine/soda/attack_hand(mob/user as mob)
	var/dat = {"<BR>Space Bubbles ([spacebubbles]) <a href=?getbubble>Press Button.<</a>!</BR>"}
	usr << browse(dat,"window=vendor")


obj/machinery/vendingmachine/soda/Topic(href,href_list[],hsrc)
	if(href == "getbubble")
		spacebubbles--
		var/obj/items/weapon/cans/spacebubble/S = new(src)
		s.loc = src.loc
		*/