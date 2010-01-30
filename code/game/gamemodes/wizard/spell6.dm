/obj/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon = 'mob.dmi'
	icon_state = "shield"
	anchored = 1.0
	opacity = 0
	density = 1

/client/proc/forcewall()

	set category = "Spells"
	set name = "Forcewall"
	set desc = "Create a forcewall on your location."
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
	usr.verbs -= /client/proc/forcewall
	spawn(100)
		usr.verbs += /client/proc/forcewall
	var/forcefield
	var/mob/human/G = usr
	G.say("TARCOL MINTI ZHERI")
	forcefield =  new /obj/forcefield(locate(usr.x,usr.y,usr.z))
	spawn (300)
		del (forcefield)
	return
