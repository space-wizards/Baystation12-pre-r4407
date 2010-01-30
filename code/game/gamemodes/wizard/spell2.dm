/mob/proc/kill(mob/M as mob in oview(1))
	set category = "Spells"
	set name = "Shocking Grasp"
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
	usr.verbs -= /mob/proc/kill
	spawn(600)
		usr.verbs += /mob/proc/kill
	usr.say("EI NATH")
	var/obj/effects/sparks/O = new /obj/effects/sparks( M.loc )
	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn( 0 )
		O.Life()
	M << text("\blue You feel a deadly shock flow through you.")
	M.fireloss = 100
	M.toxloss = 100
	M.bruteloss = 100
	M.oxyloss = 100
	M.health = -100
	M.updatehealth()
	if(M.stat < 2) M.stat=2
	..()
//	usr << "\blue Killing [M]!"
//	messageadmins("\red Admin [usr.key] killed [M]!")
//	world.log_admin("[usr.key] killed [M]!")
	return
