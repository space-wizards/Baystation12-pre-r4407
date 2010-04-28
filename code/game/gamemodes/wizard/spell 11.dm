/client/proc/hulk()
	set category = "Spells"
	set name = "Transformation"
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
	usr.verbs -= /client/proc/hulk
	spawn(600)
		usr.verbs += /client/proc/hulk
	usr.say("BIRUZ BENNAR")
	usr << text("\blue You feel strong!")
	usr.ishulk = 1
	usr.unlock_medal("Its Not Easy Being Green", 1, "Become the hulk.", "medium")
	spawn (300)
		usr.ishulk = 0
	return
