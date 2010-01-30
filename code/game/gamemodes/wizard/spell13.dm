/client/proc/blink()
	set category = "Spells"
	set name = "Blink"
	set desc="Blink"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return
	if(!istype(usr:head, /obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough without my hat."
		return
	if(!istype(usr:l_hand, /obj/item/weapon/staff) && !istype(usr:r_hand, /obj/item/weapon/staff))
		usr << "I don't feel strong enough without my staff."
		return
	var/list/turfs = list()
	usr.verbs -= /client/proc/blink
	spawn(20)
		usr.verbs += /client/proc/blink
	for(var/turf/T in orange(5))
		if(T.x>world.maxx-4 || T.x<4)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-4 || T.y<4)	continue
		turfs += T
	var/obj/effects/smoke/Y = new /obj/effects/smoke( usr.loc )
	Y.amount = 1
	Y.dir = pick(1, 2, 4, 8)
	spawn( 0 )
		Y.Life()
	usr.loc = pick(turfs)