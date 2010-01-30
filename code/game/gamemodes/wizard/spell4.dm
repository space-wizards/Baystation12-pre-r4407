/client/proc/fireball(mob/T as mob in oview())
	set category = "Spells"
	set name = "Fireball"
	set desc="Fireball target:"
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
	usr.verbs -= /client/proc/fireball
	spawn(200)
		usr.verbs += /client/proc/fireball
	var/mob/human/G = usr
	var/startx = usr.x
	var/starty = usr.y
	var/endx = T.x
	var/endy = T.y
	G.say("FALIAH DEE ZERTHIA")
	var/obj/meteor/M
	M = new /obj/meteor(locate(startx, starty, 1))
	M.dest = locate(endx, endy, 1)
	walk_towards(M, M.dest, 1)
	spawn (100)
		del (M)
	return
