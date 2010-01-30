/client/proc/knock()
	set category = "Spells"
	set name = "Knock"
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
	var/densetitty
	usr.verbs -= /client/proc/knock
	spawn(100)
		usr.verbs += /client/proc/knock
	for(var/obj/G in oview(1))
		densetitty = G.density
		G.density = 0
		flick("nothing",G)
		spawn (20)
			G.density = densetitty
	usr.say("AULIE OXIN FIERA")
	return
