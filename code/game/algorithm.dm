/world/New()
	..()
	crban_loadbanfile()
	crban_updatelegacybans()
	jobban_loadbanfile()
	jobban_updatelegacybans()
	sd_SetDarkIcon('sd_dark_alpha7.dmi', 7)
	spawn(0)
		SetupOccupationsList()
		return
	return

/mob/human/verb/char_setup()
	set name = "Character Setup"

	if (src.start)
		return
	src.ShowChoices()
	return

/mob/human/proc/ShowChoices()

	var/list/destructive = assistant_occupations.Copy()
	var/dat = "<html><body>"
	dat += "<b>Name:</b> <a href=\"byond://?src=\ref[src];rname=input\"><b>[src.rname]</b></a> (<A href=\"byond://?src=\ref[src];rname=random\">&reg;</A>)<br>"
	dat += "<b>Gender:</b> <a href=\"byond://?src=\ref[src];gender=input\"><b>[src.gender == "male" ? "Male" : "Female"]</b></a><br>"
	dat += "<b>Age:</b> <a href='byond://?src=\ref[src];age=input'>[src.age]</a>"

	dat += "<hr><b>Occupation Choices</b><br>"
	if (destructive.Find(src.occupation1))
		dat += text("\t<a href=\"byond://?src=\ref[];occ=1\"><b>[]</b></a><br>", src, src.occupation1)
	else
		if (src.occupation1 != "No Preference")
			dat += text("\tFirst Choice: <a href=\"byond://?src=\ref[];occ=1\"><b>[]</b></a><br>", src, src.occupation1)
			if (destructive.Find(src.occupation2))
				dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\"><b>[]</b></a><BR>", src, src.occupation2)
			else
				if (src.occupation2 != "No Preference")
					dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\"><b>[]</b></a><BR>", src, src.occupation2)
					if (destructive.Find(src.occupation3))
						dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\"><b>[]</b></a><BR>", src, src.occupation3)
					else
						if (src.occupation3 != "No Preference")
							dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\"><b>[]</b></a><BR>", src, src.occupation3)
						else
							dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\">No Preference</a><br>", src)
				else
					dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\">No Preference</a><br>", src)
		else
			dat += text("\t<a href=\"byond://?src=\ref[];occ=1\">No Preference</a><br>", src)

	dat += "<hr><b>Body</b><br>"
	dat += "Blood Type: <a href='byond://?src=\ref[src];b_type=input'>[src.b_type]</a><br>"
	dat += "Skin Tone: <a href='byond://?src=\ref[src];ns_tone=input'>[-src.ns_tone + 35]/220</a><br>"
	if (!IsGuestKey(src.key))
		dat += "Nudist: <a href =\"byond://?src=\ref[src];b_nudist=1\"><b>[(src.be_nudist ? "Yes" : "No")]</b></a><br>"

	dat += "<hr><b>Hair</b><br>"

	dat += "Color: <font color=\"#[num2hex(src.nr_hair, 2)][num2hex(src.ng_hair, 2)][num2hex(src.nb_hair)]\">test</font><br>"
	dat += " <font color=\"#[num2hex(src.nr_hair, 2)]0000\">Red</font> - <a href='byond://?src=\ref[src];nr_hair=input'>[src.nr_hair]</a>"
	dat += " <font color=\"#00[num2hex(src.ng_hair, 2)]00\">Green</font> - <a href='byond://?src=\ref[src];ng_hair=input'>[src.ng_hair]</a>"
	dat += " <font color=\"#0000[num2hex(src.nb_hair, 2)]\">Blue</font> - <a href='byond://?src=\ref[src];nb_hair=input'>[src.nb_hair]</a><br>"
	dat += "Style: <a href='byond://?src=\ref[src];h_style=input'>[src.h_style]</a>"

	dat += "<hr><b>Facial</b><br>"

	dat += "Color: <font color=\"#[num2hex(src.nr_facial, 2)][num2hex(src.ng_facial, 2)][num2hex(src.nb_facial)]\">test</font><br>"
	dat += " <font color=\"#[num2hex(src.nr_facial, 2)]0000\">Red</font> - <a href='byond://?src=\ref[src];nr_facial=input'>[src.nr_facial]</a>"
	dat += " <font color=\"#00[num2hex(src.ng_facial, 2)]00\">Green</font> - <a href='byond://?src=\ref[src];ng_facial=input'>[src.ng_facial]</a>"
	dat += " <font color=\"#0000[num2hex(src.nb_facial, 2)]\">Blue</font> - <a href='byond://?src=\ref[src];nb_facial=input'>[src.nb_facial]</a><br>"
	dat += "Style: <a href='byond://?src=\ref[src];f_style=input'>[src.f_style]</a>"

	dat += "<hr><b>Eyes</b><br>"
	dat += "Color:</b> <font color=\"#[num2hex(src.r_eyes, 2)][num2hex(src.g_eyes, 2)][num2hex(src.b_eyes, 2)]\">test</font><br>"
	dat += " <font color=\"#[num2hex(src.r_eyes, 2)]0000\">Red</font> - <a href='byond://?src=\ref[src];r_eyes=input'>[src.r_eyes]</a>"
	dat += " <font color=\"#00[num2hex(src.g_eyes, 2)]00\">Green</font> - <a href='byond://?src=\ref[src];g_eyes=input'>[src.g_eyes]</a>"
	dat += " <font color=\"#0000[num2hex(src.b_eyes, 2)]\">Blue</font> - <a href='byond://?src=\ref[src];b_eyes=input'>[src.b_eyes]</a>"

	dat += "<hr><b>Disabilities</b><br>"
	dat += "<i>It is more than likely pretty fucking stupid to enable any of these.</i><br>"
	dat += text("Need Glasses: <a href=\"byond://?src=\ref[];n_gl=1\"><b>[]</b></a><br>", src, (src.need_gl ? "Yes" : "No"))
	dat += text("Epileptic: <a href=\"byond://?src=\ref[];b_ep=1\"><b>[]</b></a><br>", src, (src.be_epil ? "Yes" : "No"))
	dat += text("Tourette Syndrome: <a href=\"byond://?src=\ref[];b_tur=1\"><b>[]</b></a><br>", src, (src.be_tur ? "Yes" : "No"))
	dat += text("Chronic Cough: <a href=\"byond://?src=\ref[];b_co=1\"><b>[]</b></a><br>", src, (src.be_cough ? "Yes" : "No"))
	dat += text("Stutter: <a href=\"byond://?src=\ref[];b_stut=1\"><b>[]</b></a><br>", src, (src.be_stut ? "Yes" : "No"))

	dat += "<hr>"
	dat += text("<b>Music toggle:</b> <a href =\"byond://?src=\ref[];b_music=1\"><b>[]</b></a><br>", src, (src.be_music ? "Yes" : "No"))
	dat += text("<b>Be syndicate?:</b> <a href =\"byond://?src=\ref[];b_syndicate=1\"><b>[]</b></a><br>", src, (src.be_syndicate ? "Yes" : "No"))

	dat += "<hr>"

	if (!IsGuestKey(src.key))
		dat += "<a href='byond://?src=\ref[src];load=1'>Load Setup</a><br>"
		dat += "<a href='byond://?src=\ref[src];save=1'>Save Setup</a><br>"

	dat += "<a href='byond://?src=\ref[src];reset_all=1'>Reset Setup</a><br>"
	dat += "</body></html>"

	src << browse(dat, "window=mob_occupations;size=300x640")

/mob/human/proc/SetChoices(occ)

	if (occ == null)
		occ = 1
	var/HTML = "<body>"
	HTML += "<tt><center>"
	switch(occ)
		if(1.0)
			HTML += "<b>Which occupation would you like most?</b><br><br>"
		if(2.0)
			HTML += "<b>Which occupation would you like if you couldn't have your first?</b><br><br>"
		if(3.0)
			HTML += "<b>Which occupation would you like if you couldn't have the others?</b><br><br>"
		else
	for(var/job in uniquelist(occupations + assistant_occupations) )
		if (job!="AI" || config.allow_ai)
			HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=[]\">[]</a><br>", src, occ, job, job)
		//Foreach goto(105)
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=Captain\">Captain</a><br>", src, occ)
	HTML += "<br>"
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=No Preference\">\[No Preference\]</a><br>", src, occ)
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];cancel\">\[Cancel\]</a>", src, occ)
	HTML += "</center></tt>"
	usr << browse(HTML, "window=mob_occupation;size=320x500")
	return

/mob/human/proc/SetJob(occ, job)
	if (occ == null)
		occ = 1
	if (job == null)
		job = "Captain"
	if ((!( occupations.Find(job) ) && !( assistant_occupations.Find(job) ) && job != "Captain"))
		return
	if (job=="AI" && (!config.allow_ai))
		return
	switch(occ)
		if(1.0)
			if (job == src.occupation1)
				usr << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					src.occupation1 = "No Preference"
				else
					if (job == src.occupation2)
						job = src.occupation1
						src.occupation1 = src.occupation2
						src.occupation2 = job
					else
						if (job == src.occupation3)
							job = src.occupation1
							src.occupation1 = src.occupation3
							src.occupation3 = job
						else
							src.occupation1 = job
		if(2.0)
			if (job == src.occupation2)
				src << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					if (src.occupation3 != "No Preference")
						src.occupation2 = src.occupation3
						src.occupation3 = "No Preference"
					else
						src.occupation2 = "No Preference"
				else
					if (job == src.occupation1)
						if (src.occupation2 == "No Preference")
							src << browse(null, "window=mob_occupation")
							return
						job = src.occupation2
						src.occupation2 = src.occupation1
						src.occupation1 = job
					else
						if (job == src.occupation3)
							job = src.occupation2
							src.occupation2 = src.occupation3
							src.occupation3 = job
						else
							src.occupation2 = job
		if(3.0)
			if (job == src.occupation3)
				usr << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					src.occupation3 = "No Preference"
				else
					if (job == src.occupation1)
						if (src.occupation3 == "No Preference")
							src << browse(null, "window=mob_occupation")
							return
						job = src.occupation3
						src.occupation3 = src.occupation1
						src.occupation1 = job
					else
						if (job == src.occupation2)
							if (src.occupation3 == "No Preference")
								src << browse(null, "window=mob_occupation")
								return
							job = src.occupation3
							src.occupation3 = src.occupation2
							src.occupation2 = job
						else
							src.occupation3 = job
		else
	src.ShowChoices()
	src << browse(null, "window=mob_occupation")
	return

/mob/human/var/const
	slot_back = 1
	slot_wear_mask = 2
	slot_handcuffed = 3
	slot_l_hand = 4
	slot_r_hand = 5
	slot_belt = 6
	slot_wear_id = 7
	slot_ears = 8
	slot_glasses = 9
	slot_gloves = 10
	slot_head = 11
	slot_shoes = 12
	slot_wear_suit = 13
	slot_w_uniform = 14
	slot_l_store = 15
	slot_r_store = 16
	slot_w_radio = 17
	slot_in_backpack = 18

/mob/human/proc/equip_if_possible(obj/item/weapon/W, slot) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	if((slot == l_store || slot == r_store || slot == belt || slot == wear_id) && !src.w_uniform)
		del(W)
		return
	switch(slot)
		if(slot_back)
			if(!src.back)
				src.back = W
				equipped = 1
		if(slot_wear_mask)
			if(!src.wear_mask)
				src.wear_mask = W
				equipped = 1
		if(slot_handcuffed)
			if(!src.handcuffed)
				src.handcuffed = W
				equipped = 1
		if(slot_l_hand)
			if(!src.l_hand)
				src.l_hand = W
				equipped = 1
		if(slot_r_hand)
			if(!src.r_hand)
				src.r_hand = W
				equipped = 1
		if(slot_belt)
			if(!src.belt)
				src.belt = W
				equipped = 1
		if(slot_wear_id)
			if(!src.wear_id)
				src.wear_id = W
				equipped = 1
		if(slot_ears)
			if(!src.ears)
				src.ears = W
				equipped = 1
		if(slot_glasses)
			if(!src.glasses)
				src.glasses = W
				equipped = 1
		if(slot_gloves)
			if(!src.gloves)
				src.gloves = W
				equipped = 1
		if(slot_head)
			if(!src.head)
				src.head = W
				equipped = 1
		if(slot_shoes)
			if(!src.shoes)
				src.shoes = W
				equipped = 1
		if(slot_wear_suit)
			if(!src.wear_suit)
				src.wear_suit = W
				equipped = 1
		if(slot_w_uniform)
			if(!src.w_uniform)
				src.w_uniform = W
				equipped = 1
		if(slot_l_store)
			if(!src.l_store)
				src.l_store = W
				equipped = 1
		if(slot_r_store)
			if(!src.r_store)
				src.r_store = W
				equipped = 1
		if(slot_w_radio)
			if(!src.w_radio)
				src.w_radio = W
				equipped = 1
		if(slot_in_backpack)
			if (src.back && istype(src.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = src.back
				if(B.contents.len < 7 && W.w_class <= 3)
					W.loc = B
					equipped = 1
	if(equipped)
		W.layer = 52
	else
		del(W)


/mob/human/proc/Assign_Rank(rank, joined_late)
	if (rank == "AI" && ticker.mode.name  == "AI malfunction")
		var/obj/O = locate("landmark*ai")
		src << "\blue <B>You have been teleported to your new starting location!</B>"
		src.loc = O.loc
		src.AIize()
		return
	else if (rank == "AI")
		var/obj/S = locate(text("start*[]", rank))
		if ((istype(S, /obj/start) && istype(S.loc, /turf)))
			src << "\blue <B>You have been teleported to your new starting location!</B>"
			src.loc = S.loc
			src.AIize()
		return
	src.equip_if_possible(new /obj/item/weapon/radio/headset(src), slot_w_radio)
	src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
	if (src.disabilities & 1)
		src.equip_if_possible(new /obj/item/weapon/clothing/glasses/regular(src), slot_glasses)
	if (src.is_rev != "no" && src.is_rev < 1)
		src.is_rev = 0
	var/A = lowertext(src.rname)
	if (A == "gregory house" || A == "greg house")
		src.equip_if_possible(new /obj/item/weapon/cane(src), slot_r_hand)
	/*	if (A == "phoenix wright" && rank == "Lawyer")
		src.equip_if_possible(new /obj/item/weapon/clothing/under/blue_suit(src), slot_w_uniform)*/  //Just an idea - Trorbes 28/12/09
	switch(rank)
		if("Chaplain")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/chaplain_black(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
		if("Geneticist")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/genetics_white(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), slot_wear_suit)
		if("Chemist")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/genetics_white(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), slot_wear_suit)
		if("Janitor")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/janitor(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/shamwow(src), slot_r_store)
		if("Fire Fighter")
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet/fire_hel(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/under/firefighter_red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
		if("Station Engineer")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/engineering_yellow(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/t_scanner(src), slot_belt)
		if("Assistant")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/grey(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
		if("Forensic Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/forensics_red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/gloves/latex(src), slot_gloves)
			src.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/fcardholder(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/f_print_scanner(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/monocle(src), slot_glasses)
			src.is_rev = -1
		if("Medical Doctor")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), slot_l_hand)
		if("Captain")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/darkgreen(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet/swat_hel(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
			src.is_rev = -1
		if("Security Officer")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
//			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/storage/flashbang_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/baton(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/flash(src), slot_l_store)
			src.is_rev = -1
		if("Plasma Researcher")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), slot_shoes)
//			src.equip_if_possible(new /obj/item/weapon/clothing/suit/bio_suit(src), slot_wear_suit)
//			src.equip_if_possible(new /obj/item/weapon/clothing/head/bio_hood(src), slot_head)
		if("Head of Research")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/hor_green(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/flash(src), slot_l_store)
			src.is_rev = -1
		if("Head of Personnel")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/hop_green(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/flash(src), slot_l_store)
			src.is_rev = -1
		if("Head of Security")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/hos_green(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/flash(src), slot_l_store)
			src.is_rev = -1
		if("Head of Maintenance")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/hom_green(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), slot_belt)
//			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), slot_belt)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)
//			src.equip_if_possible(new /obj/item/weapon/flash(src), slot_l_store)
			src.is_rev = -1
		if("Atmospheric Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/atmospherics_yellow(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)
		if("Bartender")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/bartender(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/monocle(src), slot_glasses)
		if("Lawyer")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/black(src), slot_w_uniform) //To become Fancy Suit - Trorbes 28/12/09
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(src), slot_shoes)  //To become Leather Shoes - Trorbes 28/12/09
//			src.equip_if_possible(new /obj/item/weapon/storage/briefcase(src), slot_l_hand)  //Add in eventually - Trorbes 28/12/09
		else
			//this shouldn't ever happen?
			src << "UH OH! Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."
	var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id(src)
	C.registered = src.rname
	C.assignment = rank
	C.name = "[C.registered]'s ID Card ([C.assignment])"
	C.access = get_access(C.assignment)
	src.equip_if_possible(C, slot_wear_id)
	src.equip_if_possible(new /obj/item/weapon/pen(src), slot_r_store)
	src.equip_if_possible(new /obj/item/weapon/radio/signaler(src), slot_belt)
	if(rank == "Captain")
		world << "<b>[src] is the captain!</b>"
	src << "<B>You are the [rank].</B>"
	if(!joined_late)
		var/obj/S = null
		for(var/obj/start/sloc in world)
			if (sloc.name != rank)
				continue
			if (locate(/mob) in sloc.loc)
				continue
			S = sloc
			break
		if (!S)
			S = locate("start*[rank]") // use old stype
		if (istype(S, /obj/start) && istype(S.loc, /turf))
			src.loc = S.loc                                     // teleporting to starting location
//			src << "You've been teleported to your starting location"  //debug
	return

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.attack_ai(M)
