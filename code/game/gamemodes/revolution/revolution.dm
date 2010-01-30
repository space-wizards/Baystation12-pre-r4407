/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"

/datum/game_mode/revolution/announce()
	world << "<B>The current game mode is - Revolution!</B>"
	world << "<B>Some crewmembers are attempting to start a revolution!<BR>\nRevolutionaries - Kill the Captain, HoP, HoR, HoS and HoM. Convert other crewmembers (excluding the Captain, heads, and security officers) to your cause by flashing them. Protect your leaders.<BR>\nPersonnel - Protect the Captain and the heads. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head).</B>"

/datum/game_mode/revolution/post_setup()
	spawn ( 0 )
		randomchems()
	var/list/mobs = get_mob_list()
	while (mobs.len == 0)
		sleep 30
		mobs = get_mob_list()
	pick_killer()
	ticker.killer << "\blue You are a member of the revolutionaries' leadership!"
	ticker.killer2 = ticker.killer
	pick_killer()
	ticker.killer << "\blue You are a member of the revolutionaries' leadership!"
	ticker.killer3 = ticker.killer
	pick_killer()
	ticker.killer << "\blue You are the leader of the revolutionaries!"
	if(get_mobs_with_rank("Captain"))
		ticker.target = get_mobs_with_rank("Captain")[1]
	if(get_mobs_with_rank("Head of Personnel"))
		ticker.target2 = get_mobs_with_rank("Head of Personnel")[1]
	if(get_mobs_with_rank("Head of Research"))
		ticker.target3 = get_mobs_with_rank("Head of Research")[1]
	if(get_mobs_with_rank("Head of Security"))
		ticker.target4 = get_mobs_with_rank("Head of Security")[1]
	if(get_mobs_with_rank("Head of Maintenance"))
		ticker.target5 = get_mobs_with_rank("Head of Maintenance")[1]
	spawn (0)
		ticker.extend_process()

/datum/game_mode/revolution/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && istype(M, /mob/human))
			if(M.be_syndicate && M.start)
				if(M.is_rev == 0)
					mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs

/datum/game_mode/revolution/proc/pick_killer()
	var/mob/human/killer = pick(get_synd_list())
	ticker.killer = killer
	ticker.revs += killer
	spawn (100)
		killer.is_rev = 2
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
			killer << "Unfortunately, the Syndicate wasn't able to get you a radio."
		else
			var/obj/item/weapon/syndicate_uplink/T = new /obj/item/weapon/syndicate_uplink(R)
			R.traitorradio = T
			R.traitorfreq = freq
			T.name = R.name
			T.icon_state = R.icon_state
			T.origradio = R
			killer << "The Syndicate have cunningly disguised a Syndicate Uplink as your [R.name] [loc]. Simply dial the frequency [freq] to unlock it's hidden features."
			killer.store_memory("<B>Radio Freq:</B> [freq] ([R.name] [loc]).", 0, 0)
		if (killer.r_store)
			killer.equip_if_possible(new /obj/item/weapon/flash(killer), killer.slot_l_store)
		if (killer.l_store)
			killer.equip_if_possible(new /obj/item/weapon/flash(killer), killer.slot_r_store)

/datum/game_mode/revolution/proc/check_death(var/mob/M as mob)
	if (!M)
		return 1
	if (M.stat == 2)
		return 1
	return 0

/datum/game_mode/revolution/check_win()
//	world << "Debug: Game over called"
//	world << check_death(ticker.target)
//	world << check_death(ticker.target2)
//	world << check_death(ticker.target3)
//	world << check_death(ticker.killer)
//	world << check_death(ticker.killer2)
//	world << check_death(ticker.killer3)
	if (check_death(ticker.target) && check_death(ticker.target2) && check_death(ticker.target3) && check_death(ticker.target4) && check_death(ticker.target5))
		world << "<FONT size = 3><B>Revolutionary Victory</B></FONT>"
		world << "<B>The commanding staff have been killed!</B> The Revolution is victorious!"
		ticker.killer.unlock_medal("Viva la Revolution!", 1, "Successfully win a round as a revolutionary leader.", "medium")
		if (ticker.killer2)
			ticker.killer2.unlock_medal("Viva la Revolution!", 1, "Successfully win a round as a revolutionary leader.", "medium")
		if (ticker.killer3)
			ticker.killer3.unlock_medal("Viva la Revolution!", 1, "Successfully win a round as a revolutionary leader.", "medium")
		return 1
	if (check_death(ticker.killer) && check_death(ticker.killer2) && check_death(ticker.killer3))
		world << "<FONT size = 3><B>The Research Staff has stopped the revolution!</B></FONT>"
		world << "<B>The leaders of the revolution have been killed!</B>"
		return 1
	return 0

/datum/game_mode/revolution/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && M.start)
			mobs += M
	return mobs

/datum/game_mode/revolution/proc/get_human_list()
	var/list/humans = list()
	for(var/mob/human/M in world)
		if (M.client && M.start && get_rank(M) != "AI")
			humans += M
	return humans

/datum/game_mode/revolution/proc/pick_human_except(mob/human/exception)
	return pick(get_human_list() - exception)

/datum/game_mode/revolution/proc/get_target_desc(mob/target) //return a useful string describing the target
	var/targetrank = null
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["name"] == target.rname)
			targetrank = R.fields["rank"]
	return "[target.name] the [targetrank]"

/datum/game_mode/revolution/proc/get_rank(mob/M)
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["name"] == M.name)
			return R.fields["rank"]
	return null

/datum/game_mode/revolution/proc/get_mobs_with_rank(rank)
	var/list/names = list()
	var/list/mobs = list()
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["rank"] == rank)
			names += R.fields["name"]
			break
	for(var/mob/M in world)
		for(var/name in names)
			if(M.name == name)
				mobs += M
	return mobs

/datum/game_mode/revolution/proc/get_turf_loc(mob/m) //gets the location of the turf that the mob is on, or what the mob is in is on, etc
	//in case they're in a closet or sleeper or something
	var/loc = m:loc
	while(!istype(loc, /turf/))
		loc = loc:loc
	return loc
