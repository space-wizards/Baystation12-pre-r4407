/client/proc/telekinesis()
	set category = "Spells"
	set name = "Telekinesis"
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
	usr.verbs -= /client/proc/telekinesis
	spawn(600)
		usr.verbs += /client/proc/telekinesis
	usr.say("TALLI VERITHA")
	usr << text("\blue Your mind expands!")
	usr.telekinesis = 1
	spawn (300)
		usr.telekinesis = 0
	return
