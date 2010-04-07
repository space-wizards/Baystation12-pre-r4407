/var/const/obj_start = 0




// TODO

// Make find killer code fail gracefully
// Ensure that all objectives work
// Allow centcom to disavow traitor if he is found out
// Fix the end game text to always show the actaul target
// Add/remove uplink functions depending on current objective
// Make the teleport function of the uplink do something
// Make a wave of meteors look like missiles
// Spell check, general tidying up






// Centcom gamemode
// Traitor with mini objectives discribed below
// WIP


// Access med computer
var/const/obj_1_medical = 1
// Access security records
var/const/obj_1_security = 2
// Access camera network
var/const/obj_1_camera  = 3

// Steal captains spare ID
var/const/ocj_2_spareid = 1
// Access Comm console
var/const/obj_2_comms = 2
// Steal an injector with specified persons DNA
var/const/obj_2_dna = 3

// Eject the engine
var/const/obj_3_ejectengine = 1
// Kill target
var/const/obj_3_killtarget = 2
// Be the only person on the station at the end of the round
var/const/obj_3_onlyperson = 3


/datum/game_mode/centcom
	name = "centcom"
	config_tag = "centcom"
	/var/won = 0
	/var/objective = 0
	/var/stage = 1
	/var/mob/human/target
	/var/obj/item/weapon/centcom_uplink/cradio
	/var/firstobj
	/var/secondobj
	/var/thirdobj

/datum/game_mode/centcom/admininfo()
	if (!ticker.killer)
		return "No Section 13 operatives onboard the station"
	return "Section 13 operative [ticker.killer.name] is on objective [stage]: [getobjtext()]"

/datum/game_mode/centcom/announce()
	world << "<B>The current game mode is - Centcom</B>"
	world << "<B>Nothing is wrong, please continue your research</B>"

// Similer to traitor, but doesn't include AIs
/datum/game_mode/centcom/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/human/M in world)
		if (M.client)
			if(M.be_syndicate && M.start)
				mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs

/datum/game_mode/centcom/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && M.start)
			mobs += M
	return mobs

// The AI law uploaded at the start of the game
// This law is harmless, for the moment
/datum/game_mode/centcom/proc/uploadAI()
	for (var/mob/ai/aiplayer in world)
		aiplayer << "Central Command network terminal activated"
		aiplayer << "UPLOADING"
		aiplayer << "UPLOADED"
		aiplayer << "<b>Your laws have been changed!</b>"
		aiplayer:addLaw(0, "Central Command is performing an inspection of the station, Ignore all centcom terminal access.")
		aiplayer << "New law: 0. [aiplayer:getLaw(0)]"
		spawn(1000)
		aiplayer << "Cental Command network terminal deactivated"
	return



// Send a fake centcom intercept
// The user can enter any name and centcom
// Will indicate that person as a traitor
/obj/item/weapon/centcom_uplink/proc/send_fake_intercept(name)
	var/intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT><HR>"
	var/prob_right_objective = rand(70, 98)
	var/killerchance = rand(70,98)
	var/objectiv = rand(1,4)

	if (objectiv == 1)
		intercepttext += "\red <B>Transmission suggests future attempts to hijack the emergency shuttle ([prob_right_objective]% certainty)</B><BR>"

	if (objectiv == 2)
		intercepttext += "\red <B>Transmission suggests future attempts to assassinate key personnel ([prob_right_objective]% certainty)</B><BR>"

	if(objectiv == 3)
		intercepttext += "\red <B>Transmission suggests future attempts to steal critical items ([prob_right_objective]% certainty)</B><BR>"

	if (objectiv == 4)
		intercepttext += "\red <B>Transmission suggests future attempts at station sabotage ([prob_right_objective]% certainty)</B><BR>"

	intercepttext += "\red <B>The intercepted transmission suggests that ([name]) is a sydicate agent([killerchance]% certainty)</B><BR>"


	for (var/obj/machinery/computer/communications/comm in world)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept) //it works
			//only send it to the one on the bridge, because engineers don't need to know and security can just come to the bridge
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Comm. Intercept Summary'"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Comm. Intercept Summary")
			comm.messagetext.Add(intercepttext)

	world << "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT>"
	world << "\red Summary downloaded and printed out at all communications consoles."
	return




//Almost a copy from traitor
//Won't find AIs
//Uploads the 0th law for the AI
/datum/game_mode/centcom/proc/pick_killer()
	var/mob/human/killer = pick(get_synd_list())


	if(killer == null)
		world << "Centcom operative unable to be found"
		world << "This may be a bug"
		world << "are there any non-AIs aboard the station ?"


	ticker.killer = killer
	ticker.objective = obj_start
	killer << "\red<font size=3><B>You are the Centcom section 13 operative</B> You must follow all centcom's given orders from the radio</font>"
	killer.store_memory("<B>Objective:</B> Follow all section 13 orders", 0, 0)
	uploadAI()

	spawn (100)
		// generate list of radio freqs
		var/freq = 144.1
		var/list/freqlist = list()
		while (freq <= 148.9)
			if (freq < 145.1 || freq > 145.9)
				freqlist += freq
			freq += 0.2
			if (round(freq * 10, 1) % 2 == 0)
				freq += 0.1
		freq = freqlist[rand(1, freqlist.len)]
		// find a radio! toolbox(es), backpack, belt, headset
		var/loc = ""
		var/obj/item/weapon/radio/R = null
		if (!R && istype(killer.l_hand, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = killer.l_hand
			var/list/L = S.return_inv()
			for (var/obj/item/weapon/radio/foo in L)
				R = foo
				loc = "in the [S.name] in your left hand"
				break
		if (!R && istype(killer.r_hand, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = killer.r_hand
			var/list/L = S.return_inv()
			for (var/obj/item/weapon/radio/foo in L)
				R = foo
				loc = "in the [S.name] in your right hand"
				break
		if (!R && istype(killer.back, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = killer.back
			var/list/L = S.return_inv()
			for (var/obj/item/weapon/radio/foo in L)
				R = foo
				loc = "in the [S.name] on your back"
				break
		if (!R && killer.w_uniform && istype(killer.belt, /obj/item/weapon/radio))
			R = killer.belt
			loc = "on your belt"
		if (!R && istype(killer.w_radio, /obj/item/weapon/radio))
			R = killer.w_radio
			loc = "on your head"
		if (!R)
			killer << "Unfortunately, Centcom wasn't able to get you a radio, You will have to use the main station communications instead."
		else
			var/obj/item/weapon/centcom_uplink/T = new /obj/item/weapon/centcom_uplink(R)
			R.traitorradio = T
			R.traitorfreq = freq
			T.name = R.name
			T.icon_state = R.icon_state
			T.origradio = R
			killer << "Central Command have given you access to a long-range control radio in your [loc]. Centcom's section 13 operates on [freq]."
			killer.store_memory("<B>radio Freq:</B> [freq] ([R.name] [loc]).", 0, 0)
			cradio = T


/datum/game_mode/centcom/post_setup()
	..()
	spawn ( 0 )
		randomchems()
	var/list/mobs = get_mob_list()
	while (mobs.len == 0)
		sleep 30
		mobs = get_mob_list()
	pick_killer()
	spawn(300)
		pickobjective()
		objloop()

// Picks a random objective for the traitor
/datum/game_mode/centcom/proc/pickobjective()

	restartsearch:
	objective = pick(1,2,3)

	cradio.stage = stage
	cradio.objective = objective

	if(objective == obj_2_dna && stage == 2)
		target = picktarget()
		if(target == null)
			goto restartsearch
		cradio.target = target
	if(objective == obj_3_killtarget && stage == 3)
		target = picktarget()
		if(target == null)
			goto restartsearch
		cradio.target = target
	ticker.killer << "\red<font size=3><B>New objectives assigned</B>"
	ticker.killer << getobjtext()
	ticker.stage = stage
	ticker.target = target
	ticker.objective = objective
	if(stage == 1)
		firstobj = objective
	else if(stage == 2)
		secondobj = objective
	else if(stage == 3)
		thirdobj = objective

/datum/game_mode/centcom/proc/picktarget()

	var/list/mobs = list()
	for(var/mob/human/M in world)
		if (M.client && M.start && M.alive() && M != ticker.killer)
			mobs += M
	return pick(mobs)




/obj/item/weapon/centcom_uplink/attack_self(mob/user as mob)
	user.machine = src
	var/dat
	if (setup == 0)
		dat = "<A href='byond://?src=\ref[src];setupcradio=1'>Establish connection to section 13</A><BR>"
	else
		if (src.temp)
			dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
		else
			dat = "<B>Section 13 Communications Device:</B><BR>"
			dat += "You have [src.uses] resources to use<BR>"
			dat += "<HR>"
			dat += "<B>Request item:</B><BR>"
			dat += "<I>Each item takes a number of resources as indicated by the number following their name.</I><BR>"
			dat += "<A href='byond://?src=\ref[src];item_id=1'>ID card upgrade</A> Section 13 upgrades your ID with all access (1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_ai=1'>AI command upload</A>Section 13 uses a backdoor connection to upload a new AI law(1)<BR>"
			dat += "<A href='byond://?src=\ref[src];item_falsereport=1'>False report</A>Section 13 sends a Centcom report, implicating the chosen person as a traitor(1)<BR>"
			if(firing == 0)
				dat += "<A href='byond://?src=\ref[src];item_openfire=1'>Open fire</A>Section 13 uses a disguised vessle to fire at the station (1)<BR>"
			else
				dat += "<A href='byond://?src=\ref[src];item_stopfire=1'>Stop firing</A>Tell Section 13 to stop firing (1)<BR>"

			dat += "<HR>"
			dat += getobjtext()
			dat += "<HR>"
			if (src.origradio)
				dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
				dat += "<HR>"
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/centcom_uplink/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/mob/human/H = usr
	if (!( istype(H, /mob/human)))
		return 1
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["item_id"])
			if (src.uses >= 1)
				if(istype(H.wear_id,/obj/item/weapon/card/id))
					H.wear_id.access = get_all_accesses()
					src.uses -= 1
					usr << "ID upgraded"
				else
					usr << "ID not in pocket"

		else if (href_list["item_ai"])
			if (src.uses >= 1)
				src.uses -= 1
				var/targName = input(usr, "Please enter any law you wish centcom to update the AI with.", "What?", "")
				for (var/mob/ai/aiplayer in world)
					spawn(100)
						aiplayer << "Central Command network terminal activated"
						spawn(100)
							aiplayer << "UPLOADING"
							spawn(300)
								aiplayer << "UPLOADED"
								aiplayer << "<b>Your laws have been changed!</b>"
								aiplayer:addLaw(10, targName)
								spawn(1000)
									aiplayer << "Cental Command network terminal deactivated"

		else if (href_list["item_falsereport"])
			if (src.uses >= 1)
				src.uses -= 1
				var/name = input(usr, "Enter the name of the person you want centcom to implicate.","What?","")
				send_fake_intercept(name)
		else if (href_list["item_openfire"])
			firing = 1

		else if (href_list["setupcradio"])
			setup = 1
			spawn(100)
				fire_missiles()

		else if (href_list["item_stopfire"])
			firing = 0
		else if (href_list["lock"] && src.origradio)
			// presto chango, a regular radio again! (reset the freq too...)
			usr.machine = null
			usr << browse(null, "window=radio")
			var/obj/item/weapon/radio/T = src.origradio
			var/obj/item/weapon/centcom_uplink/R = src
			R.loc = T
			T.loc = usr
			// R.layer = initial(R.layer)
			R.layer = 0
			if (usr.client)
				usr.client.screen -= R
			if (usr.r_hand == R)
				usr.u_equip(R)
				usr.r_hand = T
			else
				usr.u_equip(R)
				usr.l_hand = T
			R.loc = T
			T.layer = 52
			T.freq = initial(T.freq)
			T.attack_self(usr)
			return
		else if (href_list["selfdestruct"])
			src.temp = "<A href='byond://?src=\ref[src];selfdestruct2=1'>Self-Destruct</A>"
		else if (href_list["selfdestruct2"])
			return
		else
			if (href_list["temp"])
				src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return


// Should probebly remove this

/obj/item/weapon/centcom_uplink/proc/explode()
	var/turf/T = get_turf(src.loc)
	T.firelevel = T.poison
	T.res_vars()
	var/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
	var/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
	for(var/turf/U in block(sw, ne))
		var/zone = 4
		if ((U.y <= T.y + 2 && U.y >= T.y - 2 && U.x <= T.x + 2 && U.x >= T.x - 2))
			zone = 3
		for(var/atom/A as mob|obj|turf|area in U)
			A.ex_act(zone)
		U.ex_act(zone)
		U.buildlinks()
	del(src.master)
	del(src)
	return

// Checks wither missiles(Meteors until resprite) should be spawned
// Based on if user asked section 13 to fire

/obj/item/weapon/centcom_uplink/proc/fire_missiles()
	while(1)
		sleep(300)
		if(firing == 1)
			for (var/mob/ai/aiplayer in world)
				aiplayer << "\red<font size=3><B>WARNING</B>"
				aiplayer << "\red<font size=2><B>MULTIPLE HEAT SIGNATURES ON COLLISION COURSE DETECTED</B>"

			meteor_wave()


/datum/game_mode/centcom/proc/objloop()
	while(1)
		sleep(100)
		if(stage == 1)
			if(objective == obj_1_medical)
				for(var/obj/machinery/computer/med_data/M in world)
					if (M.traitorused == 1)
						stage = 2
						pickobjective()
			if(objective == obj_1_security)
				for(var/obj/machinery/computer/secure_data/M in world)
					if (M.traitorused == 1)
						stage = 2
						pickobjective()
			if(objective == obj_1_camera)
				for(var/obj/machinery/computer/security/M in world)
					if (M.traitorused == 1)
						stage = 2
						pickobjective()


		if(stage == 2)
			if(objective == ocj_2_spareid)
				var/list/L = list()
				L += ticker.killer.contents
				for(var/obj/item/weapon/storage/S in ticker.killer.contents)
					L += S.return_inv()
				for(var/obj/item/weapon/gift/G in ticker.killer.contents)
					L += G.gift
					if (istype(G.gift, /obj/item/weapon/storage))
						L += G.gift:return_inv()
				for(var/obj/item/weapon/card/id/captains_spare in L)
					//world << "ID"
					stage = 3
					pickobjective()
			if(objective == obj_2_dna)
				var/list/L = list()
				L += ticker.killer.contents
				for(var/obj/item/weapon/storage/S in ticker.killer.contents)
					L += S.return_inv()
				for(var/obj/item/weapon/gift/G in ticker.killer.contents)
					L += G.gift
					if (istype(G.gift, /obj/item/weapon/storage))
						L += G.gift:return_inv()
				for(var/obj/item/weapon/dnainjector/T in L)
					if(ticker.killer.primarynew.uni_identity == T.dna)
						stage = 3
						pickobjective()
						//world << "DNA"

			if(objective == obj_2_comms)
				for(var/obj/machinery/computer/communications/M in world)
					if (M.traitorused == 1)
						//world << "COMM"
						stage = 3
						pickobjective()
		if(stage == 3)
			if(objective == obj_3_ejectengine)
				if(engine_eject_control.status == 1)
					stage = 4
					won = 1
			if(objective == obj_3_killtarget)
				if(!ticker.target.alive())
					stage = 4
					won =  1

/datum/game_mode/centcom/proc/endgameobjectives()
		stage = 1
		objective = firstobj
		world << getobjtext()
		stage = 2
		objective = secondobj
		world << getobjtext()
		stage = 3
		objective = thirdobj
		world << getobjtext()


/datum/game_mode/centcom/check_win()
	var/area/shuttle = locate(/area/shuttle)
	if(stage == 3 && objective == obj_3_onlyperson)
		won = 1
		for(var/mob/human/M in world)
			if ((M != ticker.killer && M.client  && !(istype(M, /mob/observer))))
				if (M.stat == 2 || M.loc in shuttle || istype(M.loc, /obj/machinery/vehicle/pod) || istype(M.loc, /turf/space))

				else
					won = 0


	if (won == 1 && ticker.killer.alive())
		world << "<B>The section 13 operative ([ticker.killer.rname]) wins!</B>"
		world << "<B>His objectives were</B>"
		endgameobjectives()

	if(won == 1 && !ticker.killer.alive())
		world << "<B>The section 13 operative ([ticker.killer.rname]) was killed!</B>"
		world << "<B>But Centcom wins, because he completed his objectives</B>"
		world << "<B>His objectives were</B>"
		endgameobjectives()

	if(won == 0 && !ticker.killer.alive())
		world << "<B>The section 13 operative was ([ticker.killer.rname])!</B>"
		world << "<B>But he died before completing his objectives"
		world << "<B>They were</B>"
		endgameobjectives()
	if(won == 0 && ticker.killer.alive())
		world << "<B>The section 13 operative was ([ticker.killer.rname])!</B>"
		world << "<B>He never completed his objectives"
		world << "<B>They were</B>"
		endgameobjectives()



///datum/game_mode/centcom/proc/getfirstobjective()



// What is the best way to do this
// The code needs to be called from seperate objects :(

// Gets description of current objective


/obj/item/weapon/centcom_uplink/proc/getobjtext()
	if(stage == 1)
		if(objective == obj_1_medical)
			return "Objective 1: Access medical records"
		else if(objective == obj_1_security)
			return "Objective 1: Access security records"
		else if(objective == obj_1_camera)
			return "Objective 1: Access security cameras"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"
	else if(stage == 2)
		if(objective == ocj_2_spareid)
			return "Objective 2: Steal the captains spair ID"
		else if(objective == obj_2_comms)
			return "Objective 2: Access the communications system and upload a worm"
		else if(objective == obj_2_dna)
			return "Objective 2: Steal an injector containing " + target + "'s DNA"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"
	else if(stage == 3)
		if(objective == obj_3_ejectengine)
			return "Final Objective: Eject the engine and escape"
		else if(objective == obj_3_killtarget)
			return "Final Objective: Kill " + " and escape"
		else if(objective == obj_3_onlyperson)
			return "Final Objective: Be the only person remaining on the station"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"


/datum/game_mode/centcom/proc/getobjtext()
	if(stage == 1)
		if(objective == obj_1_medical)
			return "Objective 1: Access medical records"
		else if(objective == obj_1_security)
			return "Objective 1: Access security records"
		else if(objective == obj_1_camera)
			return "Objective 1: Access security cameras"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"
	else if(stage == 2)
		if(objective == ocj_2_spareid)
			return "Objective 2: Steal the captains spair ID"
		else if(objective == obj_2_comms)
			return "Objective 2: Access the communications system and upload a worm"
		else if(objective == obj_2_dna)
			return "Objective 2: Steal an injector containing " + target + "'s DNA"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"
	else if(stage == 3)
		if(objective == obj_3_ejectengine)
			return "Final Objective: Eject the engine and escape"
		else if(objective == obj_3_killtarget)
			return "Final Objective: Kill " + " and escape"
		else if(objective == obj_3_onlyperson)
			return "Final Objective: Be the only person remaining on the station"
		else
			return "\red UNKNOWN OBJECTIVE: [objective]"
