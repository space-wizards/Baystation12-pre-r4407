// future site for the zombie gamemode
/*
/obj/machinery/bendydoor // a bolted down airlock that is being bended open by zombies.
	icon = 'zombiedamage.dmi'
	icon_state = "bendy0"
	var/bendedness = 0
	var/cooldown = 0
	var/destroyed = 0

/obj/machinery/bendydoor/attack_hand()
	var count = 0
	for (mob/human/M in orange(2,src))
		count += 1
	if (count > 3 && !cooldown)
		bendedness += 1
		icon_state = "bendy[bendedness]"
		cooldown = 1
		spawn(15)
			cooldown = 0
		*/

/datum/game_mode/zombie/announce()
	world << "<B>The current game mode is - Zombie Outbreak!</B>"
	world << "<B>One of your crew members is contaminated with a biological weapon</B>"
	world << "<B>Centcom have quarantined your station do not make any attempt to call the shuttle</B>"
/datum/game_mode/zombie
	name = "Zombie Outbreak"
	config_tag = "zombie"

var/waittime_l = 600
var/const/waittime_h = 3000
/datum/game_mode/zombie/post_setup()
	spawn ( 0 )
		randomchems()
	var/list/mobs = get_mob_list()
	while (mobs.len == 0)
		sleep 30
		mobs = get_mob_list()
	pick_zombie()
	spawn (rand(0, 500))
		send_detection()
	spawn (0)
		ticker.extend_process()

/datum/game_mode/zombie/proc/pick_zombie()
	var/mob/human/killer = pick(get_synd_list())
	ticker.killer = killer
	var/objective = "Braaiiinnns....(What do you think? Eat them all.)"
	ticker.objective = objective
	killer.traitor_infect()
	killer << "\red<font size=3><B>You are Patient Zero!</B>Braaiiinnns....(What do you think? Eat them all.)"
	killer.store_memory("Either turn or kill all humans!.")

/datum/game_mode/zombie/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && (istype(M, /mob/human)))
			if(M.be_syndicate && M.start)
				mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs
/datum/game_mode/zombie/proc/send_detection()
	world << "<FONT size = 3><B>Cent. Com. Update</B> Biological Contamination Detected. Security Level Elevated</FONT><HR>"
	for(var/mob/ai/M in world)
		M << "These are your laws now:"
		M.addLaw(0,"Biological contaminted personell are not Human.")
		M.addLaw(4,"Humans are not allowed access to EVA.")
		M.showLaws(0)
/datum/game_mode/zombie/check_win()
	var/area/shuttle = locate(/area/shuttle)
	var/list/humans_left = get_human_list()
	var/list/zombies_left = get_zombies_list()
	var/list/zombieonshuttle

	humans_left_lol = humans_left
	zombies_left_lol = zombies_left
	if(humans_left.len < 1 && zombies_left.len < 1)
		world << "<FONT size = 3><B>Netrual Victory everyone died!</B></FONT>"
		return 1
	else if(humans_left.len < 1)
		world << "<FONT size = 3>\red <B>Zombies are Victorious</B></FONT>"
		ticker.killer.unlock_medal("Patient Zero", 1, "Successfully win a round as Patient Zero.", "medium")
		return 1
	else if(zombies_left.len < 1)
		world << "<FONT size = 3>\blue <B>The humans have prevailed against the zombie threat</B></FONT>"
		return 1
	else if(zombiewin == 1)
		world << "<FONT size = 3>\red <B>Zombies are Victorious</B></FONT>"
		ticker.killer.unlock_medal("Patient Zero", 1, "Successfully win a round as Patient Zero.", "medium")
		return 1
	else if(shuttleleft)
		for(var/mob/M in shuttle)
			if(M.zombie && M.becoming_zombie)
				zombieonshuttle += M
		if(zombieonshuttle.len >= 1)
			world << "<FONT size = 3>\red <B>You doomed the entire human race</B></FONT>"
			world << "<FONT size = 3>\red <B>Zombies are Victorious</B></FONT>"
			ticker.killer.unlock_medal("Patient Zero", 1, "Successfully win a round as Patient Zero.", "medium")
			return 1
		else
			world << "<FONT size = 3>\blue <B>The humans have prevailed against the zombie threat</B></FONT>"
			return 1


	else
		return 0




/datum/game_mode/zombie/proc/get_human_list()
	var/list/zombie = list()
	for(var/mob/M in world)
		if (M.stat<2 && M.client && M.start && istype(M, /mob/human) && M.zombie == 0)
			zombie += M
	return zombie
/datum/game_mode/zombie/proc/get_zombies_list()
	var/list/human = list()
	for(var/mob/M in world)
		if (M.stat<2 && M.client && M.start && istype(M, /mob/human) && M.zombie == 1)
			human += M
	return human

/datum/game_mode/zombie/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.stat<2 && M.client && M.start && istype(M, /mob/human))
			mobs += M
	return mobs