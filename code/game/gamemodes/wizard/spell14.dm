/client/proc/clone()
	set category = "Spells"
	set name = "Clone"
	set desc="Clone"
	if(usr:stat >= 2)
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
//	usr:verbs -= /client/proc/clone
//	spawn(200)
//		usr:verbs += /client/proc/clone
	var/mob/human/O = new /mob/human( usr )
//	var/mob/M = usr
	O.start = 1
	O.primary = usr:primary
	var/t1 = hex2num(copytext(O.primary.uni_identity, 25, 28))
	if (t1 < 125)
		O.gender = "male"
	else
		O.gender = "female"
	usr << "Genetic Transversal Complete!"
	O << "Neural Sequencing Complete!"
	O.rname = usr:rname
	O.loc = usr:loc
	O.r_hair = usr:r_hair
	O.g_hair = usr:g_hair
	O.b_hair = usr:b_hair
	O.h_style = usr:h_style
	O.r_facial = usr:r_facial
	O.g_facial = usr:g_facial
	O.b_facial = usr:b_facial
	O.f_style = usr:f_style
	O.nr_hair = usr:nr_hair
	O.ng_hair = usr:ng_hair
	O.nb_hair = usr:nb_hair
	O.nr_facial = usr:nr_facial
	O.ng_facial = usr:ng_facial
	O.nb_facial = usr:nb_facial
	O.ns_tone = usr:ns_tone
	O.r_eyes = usr:r_eyes
	O.g_eyes = usr:g_eyes
	O.b_eyes = usr:b_eyes
	O.s_tone = usr:s_tone
	O.wear_suit = usr:wear_suit
	O.w_uniform = usr:w_uniform
	O.w_radio = usr:w_radio
	O.shoes = usr:shoes
	O.belt = usr:belt
	O.gloves = usr:gloves
	O.glasses = usr:glasses
	O.head = usr:head
	O.ears = usr:ears
	O.wear_id = usr:wear_id
	O.stand_icon = usr:stand_icon
	O.lying_icon = usr:lying_icon
	O.last_b_state = usr:last_b_state
	O.face_standing = usr:face_standing
	O.face_lying = usr:face_lying
	O.h_style_r = usr:h_style_r
	O.f_style_r = usr:f_style_r
	O.body_standing = usr:body_standing
	O.body_lying = usr:body_lying
	O.handcuffed = usr:handcuffed
	O.l_hand = usr:l_hand
	O.r_hand = usr:r_hand
	O.back = usr:back
	O.internal = usr:internal
	O.s_active = usr:s_active
	O.wear_mask = usr:wear_mask
	spawn (200)
		del (O)
	gayshit
	step(O, pick(NORTH, SOUTH, EAST, WEST))
	sleep(3)
	goto gayshit
	//M = null
//	del(M)